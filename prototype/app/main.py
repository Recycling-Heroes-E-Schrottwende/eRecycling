from fastapi import Depends, FastAPI, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy.orm import joinedload
from pydantic import BaseModel
from datetime import datetime
from typing import List
from model.database import SessionLocal, engine
#import auth


from model import models
from model import shemas
from model import posts
from model import deletes

app = FastAPI()


models.Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Get Requests


@app.get("/users/")
async def read_users(user_id: int = None, db: Session = Depends(get_db)):
    if user_id is None:
        users = db.query(models.User).all()
        return users
    else:
        user = db.query(models.User).filter(models.User.id == user_id).first()
        if user is None:
            raise HTTPException(status_code=404, detail="User not found")
        return user

@app.get("/products/")
async def read_products(user_id: int = None, product_id: int = None, db: Session = Depends(get_db)):
    query = db.query(models.Product)
    if user_id is not None:
        products = query.filter(models.Product.user_id == user_id).all()
    elif product_id is not None:
        products = query.filter(models.Product.id == product_id).first()
        if products is None:
            raise HTTPException(status_code=404, detail="Product not found")
    else:
        products = query.all()
    return products
@app.get("/images/image_location/{product_id}")
async def read_pictures(product_id: int, db: Session = Depends(get_db)):
    images = db.query(models.Image.image_location).filter(models.Image.product_id == product_id).all()
    return [image.image_location for image in images]

# Post Requests

@app.post("/create_user/")
async def create_user(user_create: shemas.User, db: Session = Depends(get_db)):
    return posts.Usercreate(user_create, db)

@app.post("/create_product/")
async def create_product(product_create: shemas.Product, db: Session = Depends(get_db)):
    return posts.Productcreate(product_create, db)

@app.post("/create_image/")
async def create_image(image_create: shemas.Image, db: Session = Depends(get_db)):
    return posts.Imagecreate(image_create, db)


@app.delete("/delete_user/{user_id}")
async def delete_user(user_id: int, db: Session = Depends(get_db)):
    deleted_user = deletes.DeleteUser(user_id, db)
    return {"message": f"User {deleted_user.id} deleted successfully"}

@app.delete("/delete_product/{product_id}")
async def delete_product(product_id: int, db: Session = Depends(get_db)):
    deleted_product =  deletes.DeleteProduct(product_id, db)
    return {"message": f"Product {deleted_product.id} deleted successfully"}
from sqlalchemy import Column, Integer, String, TIMESTAMP, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func


Base = declarative_base()

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, index=True)
    password = Column(String)
    email = Column(String, unique=True, index=True)
    created_at = Column(TIMESTAMP)

    products = relationship("Product", back_populates="user", cascade="all, delete-orphan")

class Product(Base):
    __tablename__ = "products"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    product_name = Column(String, index=True)
    price = Column(Integer)
    postcode = Column(String)
    location = Column(String)
    condition = Column(String)
    technical_details = Column(String)
    description = Column(String)
    details = Column(String)
    transfer_method = Column(String)
    created_at = Column(TIMESTAMP, server_default=func.now())

    user = relationship("User", back_populates="products")
    images = relationship("Image", back_populates="product", cascade="all, delete-orphan")

class Image(Base):
    __tablename__ = "images"

    id = Column(Integer, primary_key=True, index=True)
    product_id = Column(Integer, ForeignKey("products.id"))
    image_location = Column(String)
    created_at = Column(TIMESTAMP, server_default=func.now())

    product = relationship("Product", back_populates="images")


@app.delete("/delete_image/{image_id}")
async def delete_image(image_id: int, db: Session = Depends(get_db)):
    deleted_image =  deletes.DeleteImage(image_id, db)
    return {"message": f"Image {deleted_image.id} deleted successfully"}

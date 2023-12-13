from fastapi import Depends, FastAPI, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy.orm import joinedload
from pydantic import BaseModel
from datetime import datetime
from typing import List
from model.database import SessionLocal, engine
import auth


from model import models
from model import shemas
from model import posts
from model.shemas import UserCreate
from model.shemas import ProductCreate

app = FastAPI()
app.include_router(auth.router)

models.Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Get Requests


@app.get("/users/")
async def read_user(db: Session = Depends(get_db)):
    query = db.query(models.User)
    user = query.all()
    return user
@app.get("/users/{user_id}")
async def read_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.id == user_id).first()
    return user

@app.get("/products/")
async def read_products(db: Session = Depends(get_db)):
    query = db.query(models.Product)
    products = query.all()
    return products

@app.get("/products/by_user/{user_id}")
async def read_products(user_id: int, db: Session = Depends(get_db)):
    products = db.query(models.Product).filter(models.Product.user_id == user_id).all()
    return products

@app.get("/products/{product_id}")
async def read_products(product_id: int, db: Session = Depends(get_db)):
    products = db.query(models.Product).filter(models.Product.id == product_id).first()
    return products

@app.get("/images/image_location/{product_id}")
async def read_pictures(product_id: int, db: Session = Depends(get_db)):
    images = db.query(models.Image.image_location).filter(models.Image.product_id == product_id).all()
    return [image.image_location for image in images]

# Post Requests

@app.post("/create_user/")
async def create_user(user_create: UserCreate, db: Session = Depends(get_db)):
    return posts.Usercreate(user_create, db)

@app.post("/create_product/")
async def create_product(product_create: shemas.ProductCreate, db: Session = Depends(get_db)):
    return posts.Productcreate(product_create, db)

@app.post("/create_image/")
async def create_image(image_create: shemas.ImageCreate, db: Session = Depends(get_db)):
    return posts.Imagecreate(image_create, db)
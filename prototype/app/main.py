from fastapi import Depends, FastAPI, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy.orm import joinedload
from pydantic import BaseModel
from datetime import datetime
from typing import List


from model import models
from model import posts
from model import shemas
from model.database import SessionLocal, engine
from model.shemas import UserCreate

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

@app.get("/images/image_location")
async def read_pictures(product_id: int, db: Session = Depends(get_db)):
    images = db.query(models.Image.image_location).filter(models.Image.product_id == product_id).all()
    return [image.image_location for image in images]

# Post Requests

@app.post("/create_user/")
async def create_user(user_create: UserCreate, db: Session = Depends(get_db)):
    # Überprüfen Sie, ob die E-Mail-Adresse bereits vorhanden ist
    existing_user = db.query(models.User).filter(models.User.email == user_create.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Die E-Mail-Adresse ist bereits registriert")

    # Erstellen Sie einen neuen Benutzer
    new_user = models.User(
        username=user_create.username,
        password=user_create.password,
        email=user_create.email,
        created_at=datetime.now()
    )

    # Fügen Sie den Benutzer zur Datenbank hinzu
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user

from fastapi import Depends, FastAPI
from sqlalchemy.orm import Session

from model import models
from model.database import SessionLocal, engine

app = FastAPI()

models.Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.get("/users/")
def read_users(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    users = db.query(models.User).offset(skip).limit(limit).all()
    return users

@app.get("/products/")
def read_products(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    products = db.query(models.Product).offset(skip).limit(limit).all()
    return products

@app.get("/pictures/")
def read_pictures(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    pictures = db.query(models.Picture).offset(skip).limit(limit).all()
    return pictures

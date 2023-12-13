from sqlalchemy.orm import Session
from fastapi import HTTPException, Depends

from . import shemas, models
from datetime import datetime


def Usercreate(user_create: shemas.UserCreate, db: Session):
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

def Productcreate(product_create: shemas.ProductCreate, db: Session):
    # Erstellen Sie ein neues Produkt
    new_product = models.Product(
        user_id=product_create.user_id,
        product_name=product_create.product_name,
        price=product_create.price,
        postcode=product_create.postcode,
        location=product_create.location,
        condition=product_create.condition,
        technical_details=product_create.technical_details,
        description=product_create.description,
        details=product_create.details,
        transfer_method=product_create.transfer_method,
        created_at=datetime.now()
    )
    # Fügen Sie den Benutzer zur Datenbank hinzu
    db.add(new_product)
    db.commit()
    db.refresh(new_product)

    return new_product

def Imagecreate(image_create: shemas.ImageCreate, db: Session):
    # Erstellen Sie ein neues Bild
    new_image = models.Picture(
        product_id=image_create.product_id,
        image_location=image_create.image_location,
        created_at=datetime.now()
    )
    # Fügen Sie den Benutzer zur Datenbank hinzu
    db.add(new_image)
    db.commit()
    db.refresh(new_image)

    return new_image
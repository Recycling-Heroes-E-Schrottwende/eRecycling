from sqlalchemy.orm import Session
from fastapi import HTTPException, Depends

from . import shemas, models, utils
from datetime import datetime, timedelta

def Usercreate(user_create: shemas.User, db: Session):
    existing_user = db.query(models.User).filter(models.User.username == user_create.username).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Der Username wird schon verwendet")

    # Erstellen Sie einen neuen Benutzer
    new_user = models.User(
        username=user_create.username,
        created_at=datetime.now()
    )

    # Fügen Sie den Benutzer zur Datenbank hinzu
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return {"user": new_user}

def Productcreate(product_create: shemas.Product, db: Session):
    # Erstellen Sie ein neues Produkt
    new_product = models.Product(
        user_id=product_create.user_id,
        product_name=product_create.product_name,
        price=product_create.price,
        postcode=product_create.postcode,
        location=product_create.location,
        condition=product_create.condition,
        category=product_create.category,
        brand=product_create.brand,
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

def Imagecreate(image_create: shemas.Image, db: Session):
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

def addfavourite(addfavourite: shemas.Favourite, db: Session):
    # Check if the product exists
    product = db.query(models.Product).filter(models.Product.id == addfavourite.product_id).first()
    if not product:
        return HTTPException(status_code=404, detail="Product not found")

    new_favourite = models.Favourite(
        user_id = addfavourite.user_id,
        product_id = addfavourite.product_id
    )
    db.add(new_favourite)
    db.commit()
    db.refresh(new_favourite)
    return "Added a new Favourite"
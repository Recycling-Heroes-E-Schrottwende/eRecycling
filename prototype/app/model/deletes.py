from sqlalchemy.orm import Session
from fastapi import HTTPException, Depends

from . import shemas, models
from datetime import datetime
from . import miniouploader


from fastapi import HTTPException

def delete_User(id: int, db: Session):
    user = db.query(models.User).filter(models.User.id == id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    products = db.query(models.Product).filter(models.Product.user_id == id).all()

    for product in products:
        image_ids = db.query(models.Image.id).filter(models.Image.product_id == product.id).all()
        for image_id in image_ids:
            miniouploader.delete_image('pictures', product.id, image_id[0])

    try:
        db.delete(user)
        db.commit()
        return user
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {e}")
    finally:
        db.close()


def delete_Product(id: int, db: Session):
    product = db.query(models.Product).filter(models.Product.id == id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    query = db.query(models.Image)
    query = query.with_entities(models.Image.id).filter(models.Image.product_id == id).all()
    image_ids = [id for (id,) in query]

    for image_id in image_ids:
        miniouploader.delete_image('pictures', id, image_id)

    try:
        db.delete(product)
        db.commit()
        return product
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {e}")
    finally:
        db.close()


def delete_Image(id: int, db: Session):
    image = db.query(models.Image).filter(models.Image.id == id).first()
    if not image:
        raise HTTPException(status_code=404, detail="Image not found")

    try:
        db.delete(image)
        db.commit()
        return image
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {e}")
    finally:
        db.close()

def delete_favourite(user_id: int, product_id: int, db: Session):
    favourite = db.query(models.Favourite).filter(models.Favourite.user_id == user_id, models.Favourite.product_id == product_id).first()
    if not favourite:
        raise HTTPException(status_code=404, detail="Favourite not found")

    try:
        db.delete(favourite)
        db.commit()
        return favourite
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {e}")
    finally:
        db.close()

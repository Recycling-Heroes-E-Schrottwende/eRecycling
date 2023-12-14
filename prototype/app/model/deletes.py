from sqlalchemy.orm import Session
from fastapi import HTTPException, Depends

from . import shemas, models
from datetime import datetime


from fastapi import HTTPException

def DeleteUser(id: int, db: Session):
    user = db.query(models.User).filter(models.User.id == id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    try:
        db.delete(user)
        db.commit()
        return user
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {e}")
    finally:
        db.close()


def DeleteProduct(id: int, db: Session):
    product = DB.query(models.Product).filter(models.Product.id == id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")

    try:
        db.delete(product)
        db.commit()
        return product
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Internal Server Error: {e}")
    finally:
        db.close()


def DeleteImage(id: int, db: Session):
    image = DB.query(models.Image).filter(models.Image.id == id).first()
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
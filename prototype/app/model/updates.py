# updates.py

from sqlalchemy.orm import Session
from . import shemas, models

class UpdateUser:
    def __init__(self, user_id: int, user_update: shemas.User, db: Session):
        self.user_id = user_id
        self.user_update = user_update
        self.db = db

    def update_user(self):
        db_user = self.db.query(models.User).filter(models.User.id == self.user_id).first()
        if db_user:
            for field, value in vars(self.user_update).items():
                setattr(db_user, field, value) if value is not None else None
            self.db.commit()
            self.db.refresh(db_user)
            return db_user
        return None

class UpdateProduct:
    def __init__(self, product_id: int, product_update: shemas.Product, db: Session):
        self.product_id = product_id
        self.product_update = product_update
        self.db = db

    def update_product(self):
        db_product = self.db.query(models.Product).filter(models.Product.id == self.product_id).first()
        if db_product:
            for field, value in vars(self.product_update).items():
                setattr(db_product, field, value) if value is not None else None
            self.db.commit()
            self.db.refresh(db_product)
            return db_product
        return None

class UpdateImage:
    def __init__(self, image_id: int, image_update: shemas.Image, db: Session):
        self.image_id = image_id
        self.image_update = image_update
        self.db = db

    def update_image(self):
        db_image = self.db.query(models.Image).filter(models.Image.id == self.image_id).first()
        if db_image:
            for field, value in vars(self.image_update).items():
                setattr(db_image, field, value) if value is not None else None
            self.db.commit()
            self.db.refresh(db_image)
            return db_image
        return None

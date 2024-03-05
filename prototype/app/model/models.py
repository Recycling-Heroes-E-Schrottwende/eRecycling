from sqlalchemy import Column, Integer, String, TIMESTAMP, ForeignKey, ForeignKeyConstraint
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func


Base = declarative_base()

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, index=True)
    created_at = Column(TIMESTAMP)

    products = relationship("Product", back_populates="user", cascade="all, delete-orphan")
    favourites = relationship("Favourite", back_populates="user", cascade="all, delete-orphan")

class Product(Base):
    __tablename__ = "products"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    product_name = Column(String, index=True)
    price = Column(Integer)
    postcode = Column(String)
    location = Column(String)
    condition = Column(String)
    category = Column(String)
    brand = Column(String)
    technical_details = Column(String)
    description = Column(String)
    details = Column(String)
    transfer_method = Column(String)
    created_at = Column(TIMESTAMP, server_default=func.now())

    user = relationship("User", back_populates="products")
    images = relationship("Image", back_populates="product", cascade="all, delete-orphan")
    favourites = relationship("Favourite", back_populates="product", cascade="all, delete-orphan")

class Image(Base):
    __tablename__ = "images"

    id = Column(Integer, primary_key=True, index=True)
    product_id = Column(Integer, ForeignKey("products.id"))
    created_at = Column(TIMESTAMP, server_default=func.now())

    product = relationship("Product", back_populates="images")

class Favourite(Base):
    __tablename__ = "favourites"

    user_id = Column(Integer, ForeignKey("users.id"), primary_key=True)
    product_id = Column(Integer, ForeignKey("products.id"), primary_key=True)


    user = relationship("User", back_populates="favourites")
    product = relationship("Product", back_populates="favourites")

    __table_args__ = (
        ForeignKeyConstraint(['user_id'], ['users.id']),
        ForeignKeyConstraint(['product_id'], ['products.id']),
    )

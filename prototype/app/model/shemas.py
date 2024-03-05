from pydantic import BaseModel

class User(BaseModel):
    username: str

class Product(BaseModel):
    user_id: int
    product_name: str
    price: float
    postcode: str
    location: str
    condition: str
    category: str
    brand: str
    technical_details: str
    description: str
    details: str
    transfer_method: str

class Image(BaseModel):
    product_id: int

class Favourite(BaseModel):
    user_id: int
    product_id: int

class UserResponse(BaseModel):
    id: int
    username: str
    email: str

    class Config:
        orm_mode = True

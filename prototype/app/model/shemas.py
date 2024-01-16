from pydantic import BaseModel

class User(BaseModel):
    username: str
    password: str
    email: str

class Product(BaseModel):
    user_id: int
    product_name: str
    price: int
    postcode: str
    location: str
    condition: str
    technical_details: str
    description: str
    details: str
    transfer_method: str

class Image(BaseModel):
    product_id: int
    image_location: str


class UserResponse(BaseModel):
    id: int
    username: str
    email: str

    class Config:
        orm_mode = True

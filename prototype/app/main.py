from fastapi import Depends, FastAPI, HTTPException, File, UploadFile, Security
from sqlalchemy.orm import Session
from sqlalchemy.orm import joinedload
from pydantic import BaseModel
from datetime import datetime
from typing import List
from model.database import SessionLocal, engine
from fastapi.responses import FileResponse
from starlette import status
from io import BytesIO
from typing_extensions import Annotated
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import APIKeyHeader
import os.path


from model import models
from model import shemas
from model import posts
from model import deletes
from model.shemas import User
from model.updates import UpdateUser
from model.updates import UpdateProduct
from model.shemas import Product
from model.updates import UpdateImage
from model.shemas import Image
from model import utils
from model import miniouploader

app = FastAPI()

api_key_header = APIKeyHeader(name="Api_Key")
#api_key = os.getenv("API_KEY")
api_key = "key"

models.Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

origins = [
    "*",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


def get_api_key(api_key_header: str = Security(api_key_header)) -> str:
    if api_key_header == api_key:
        print("hello")
        return api_key_header
    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid or missing API Key",
    )


# Get Requests

@app.get("/users/")
async def read_users(api_key: str = Security(get_api_key), user_id: int = None, db: Session = Depends(get_db)):
    if user_id is None:
        users = db.query(models.User).all()
        return users
    else:
        user = db.query(models.User).filter(models.User.id == user_id).first()
        if user is None:
            raise HTTPException(status_code=404, detail="User not found")
        return user

@app.get("/products/")
async def read_products(user_id: int = None, product_id: int = None, condition: str = None, transfer_method: str = None, location: str = None, category: str = None, brand: str = None, db: Session = Depends(get_db)):
    query = db.query(models.Product)
    if user_id is None and product_id is None and condition is None and transfer_method is None and location is None:
        products = query.all()
        return products
    if user_id:
        query = query.filter(models.Product.user_id == user_id)
    if product_id:
        query = query.filter(models.Product.id == product_id)     
    if condition:
        query = query.filter(models.Product.condition == condition)
    if transfer_method:
        query = query.filter(models.Product.transfer_method == transfer_method)
    if location:
        query = query.filter(models.Product.location == location)
    if category:
        query = query.filter(models.Product.category == category)
    if brand:
        query = query.filter(models.Product.brand == brand)

    products = query.all()
    return products

@app.get("/picture_url")
async def get_presigned_url(product_id: int):
    url = miniouploader.create_presigned_url("pictures", product_id)
    return {"url": url}

@app.get("/favourites/")
async def read_favourites(user_id: int, db: Session = Depends(get_db)):
    favourites = db.query(models.Favourite).filter(models.Favourite.user_id == user_id).all()
    return favourites

# Post Requests

@app.post("/create_user/")
async def create_user(user_create: shemas.User, db: Session = Depends(get_db)):
    return posts.Usercreate(user_create, db)

@app.post("/create_product/")
async def create_product(product_create: shemas.Product, db: Session = Depends(get_db)):
    return posts.Productcreate(product_create, db)

@app.post("/uploadImage/")
async def upload_image(product_id: int, file: UploadFile = File(...), db: Session = Depends(get_db)):
    bucket_name = "pictures"

    # Create a new database entry and get the id
    new_image = models.Image(product_id=product_id, created_at=datetime.now())
    db.add(new_image)
    db.commit()
    db.refresh(new_image)
    id = new_image.id

    destination_file = f"{product_id}-{id}.webp"

    # Read the file
    file_content = await file.read()

    # Upload the file to MinIO
    result = miniouploader.upload_to_minio(bucket_name, destination_file, file_content)

    return result

@app.post("/addFavourite/")
async def add_favourite(add_favourites: shemas.Favourite, db: Session = Depends(get_db)):
    return posts.addfavourite(add_favourites, db)


# Delete Requests
@app.delete("/delete_user/{user_id}")
async def delete_user(user_id: int, db: Session = Depends(get_db)):
    deleted_user = deletes.DeleteUser(user_id, db)
    return {"message": f"User {deleted_user.id} deleted successfully"}

@app.delete("/delete_product/{product_id}")
async def delete_product(product_id: int, db: Session = Depends(get_db)):
    deleted_product =  deletes.DeleteProduct(product_id, db)
    return {"message": f"Product {deleted_product.id} deleted successfully"}

@app.delete("/delete_image/")
async def delete_image(image_id: int, product_id: int, db: Session = Depends(get_db)):
    deleted_image =  deletes.DeleteImage(image_id, db)
    miniouploader.delete_image("pictures", product_id, image_id)
    return {"message": f"Image {deleted_image.id} deleted successfully"}
    #return {"message": f"Image deleted successfully"}

@app.delete("/delete_favourite/")
async def delete_favourite(user_id: int, product_id: int, db: Session = Depends(get_db)):
    deleted_favourite =  deletes.deletefavourite(user_id, product_id, db)
    return {"message": f"Favourite {deleted_favourite.user_id} deleted successfully"}


# Update Requests
@app.put("/update_user/{user_id}")
async def update_user(user_id: int, user_update: User, db: Session = Depends(get_db)):
    updated_user = UpdateUser(user_id, user_update, db).update_user()
    if updated_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return updated_user

@app.put("/update_product/{product_id}")
async def update_product(product_id: int, product_update: Product, db: Session = Depends(get_db)):
    updated_product = UpdateProduct(product_id, product_update, db).update_product()
    if updated_product is None:
        raise HTTPException(status_code=404, detail="Product not found")
    return updated_product
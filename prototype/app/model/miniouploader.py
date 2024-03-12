from minio import Minio
from minio.error import S3Error
import io
from datetime import timedelta
import os

client = Minio(
        "172.17.0.1:9000",
        access_key="IAL0YRiMfz0xRDkQZcbb",
        secret_key="fZb4MJXFnauK0XPEin5cFTHlwbBD1uabsIbzTIst",
        secure=False
    )
    
def upload_to_minio(bucket_name, destination_file, file_content):
    try:
        client.put_object(bucket_name, destination_file, io.BytesIO(file_content), len(file_content))
        return destination_file
    except S3Error as err:
        print(err)

def create_presigned_url(bucket_name, product_id):
    image_urls = []

    objects = client.list_objects(bucket_name, prefix=f"{product_id}-", recursive=True)
    object_name = None
    try: 
        for obj in objects:
            object_name = obj.object_name
            presigned_url = client.presigned_get_object(bucket_name, object_name, timedelta(hours=1))        
            image_urls.append(presigned_url)
        return image_urls
    except S3Error as err:
        print(err)

def delete_image(bucket_name, product_id, picture_id):
    object_name = f"{product_id}-{picture_id}.webp"
    try:
        client.remove_object(bucket_name, object_name)
        return "Successfully deleted image"
    except S3Error as err:
        print(err)
    return "Successfully deleted image"

from minio import Minio
from minio.error import S3Error
import io
from datetime import timedelta
import os


def upload_to_minio(bucket_name, destination_file, file_content):
    client = Minio(
        "172.17.0.3:9000",
        access_key=os.getenv("access_key"),
        secret_key=os.getenv("secret_key"),
        secure=False
    )

    try:
        client.put_object(bucket_name, destination_file, io.BytesIO(file_content), len(file_content))
        return destination_file
    except S3Error as err:
        print(err)

def create_presigned_url(bucket_name, object_name):
    client = Minio(
        "172.17.0.3:9000",
        access_key=os.getenv("access_key"),
        secret_key=os.getenv("secret_key"),
        secure=False
    )

    try:
        presigned_url = client.presigned_get_object(bucket_name, object_name, timedelta(hours=1))        
        return presigned_url
    except S3Error as err:
        print(err)
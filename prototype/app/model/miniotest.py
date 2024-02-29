from minio import Minio
from minio.error import S3Error

def main():
    
    client = Minio("172.17.0.3:9000", access_key="IAL0YRiMfz0xRDkQZcbb", secret_key="fZb4MJXFnauK0XPEin5cFTHlwbBD1uabsIbzTIst", secure=False)


    source_file = "/home/noah/Documents/Test.txt"

    bucket_name = "pictures"
    destination_file = "my-test-file.txt"

    client.fput_object(
        bucket_name, destination_file, source_file,
    )
    print(
        source_file, "successfully uploaded as object",
        destination_file, "to bucket", bucket_name,
    )

if __name__ == "__main__":
    try:
        main()
    except S3Error as exc:
        print("error occurred.", exc)

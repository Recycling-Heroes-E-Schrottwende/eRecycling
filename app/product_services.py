import requests
from werkzeug.utils import secure_filename
import os

class ProductService:
    def __init__(self):
        #self.url = "http://localhost:8000/"
        self.url = "http://app.recyclingheroes.at/api/"

    def get_products(self):
        headers = {"X-API-Key": "#Baum9Gebaeude5Laptop"}
        response = requests.get(self.url + "products/", headers=headers)
        if response.status_code == 200:
            return response.json()
        else:
            return {'error': 'Failed to load products'}, 404

    def get_new_products(self):
        response = requests.get(self.url + "products/")
        if response.status_code == 200:
            sorted_products = sorted(response.json(), key=lambda x: x["created_at"], reverse=True)
            new_products = sorted_products[:10]
            return new_products
        else:
            return {'error': 'Failed to load new products'}, 404

    def get_favourites(self):
        response = requests.get(self.url + "favourites/?user_id=10")
        if response.status_code == 200:
            return response.json()
        else:
            return {'error': 'Failed to load products'}, 404

    def get_product_by_id(self, product_id):
        response = requests.get(self.url + f"products/?product_id={product_id}")
        if response.status_code == 200:
            data = response.json()
            if isinstance(data, list) and len(data) == 1:
                return data[0]
            else:
                return {'error': 'Product not found or more than one product found'}, 404

    def get_image(self, product_id):
        response = requests.get(self.url + f"picture_url/?product_id={product_id}")
        
        try:
            if response.status_code == 200:
                return response.json()["url"][0]
            else:
                return {'error': 'Image not found or failed to load'}
        except:
            return {'error': 'Image not found or failed to load'}

    def post_product(self, title, desc, category, condition, delivery, postcode, price):
        product_data = {
            "user_id": 10,
            "product_name": title,
            "description": desc,
            "location": "test",
            "category": category,
            "technical_details": "test",
            "details": "test",
            "price": price,
            "postcode": postcode,
            "condition": condition,
            "brand": "test",
            "transfer_method": delivery
        }
        print(product_data)
        response = requests.post(self.url + "create_product/", json=product_data)

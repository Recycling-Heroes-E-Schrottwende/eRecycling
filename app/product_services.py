import requests
from werkzeug.utils import secure_filename
import os

class ProductService:
    def __init__(self):
        self.url = "http://app.recyclingheroes.at/api/"

    def get_products(self):
        response = requests.get(self.url + "products/")
        if response.status_code == 200:
            return response.json()
        else:
            return {'error': 'Failed to load products'}, 404

    def get_new_products(self):
        response = requests.get(self.url + "products/new")
        if response.status_code == 200:
            return response.json()
        else:
            return {'error': 'Failed to load new products'}, 404

    def get_product_by_id(self, product_id):
        response = requests.get(self.url + f"products/?product_id={product_id}")
        if response.status_code == 200:
            data = response.json()
            if isinstance(data, list) and len(data) == 1:
                return data[0]
            else:
                return {'error': 'Product not found or more than one product found'}, 404

    def get_image(self, product_id):
        response = requests.get(self.url + f"images/image_location/{product_id}")
        if response.status_code == 200:
            return response.json()
        else:
            return {'error': 'Image not found or failed to load'}, 404

    def post_product(self, title, image, desc):
        if image:
            filename = secure_filename(image.filename)
            image.save(os.path.join("./" + filename))
        
        print(title)
        print(desc)
        # Logik zum Speichern von Titel und Beschreibung...
        #return jsonify({'message': 'Produkt erstellt'}), 200
        #print("Title: ", title)
        #print("Desc: ", desc)
        #response = requests.post(self.url + "create/product", json=product_data)
        #return response.json()
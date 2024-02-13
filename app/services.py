import requests

class ProductService:
    def __init__(self):
        self.url = "http://app.recyclingheroes.at/"
        #self.url = "http://localhost:8000/"

    def get_products(self):
        response = requests.get(self.url + "products/")
        return response.json()

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

    def post_product(self, product_data):
        response = requests.post(self.url + "products/", json=product_data)
        return response.json()

class UserService:
    def __init__(self):
        self.url = "http://app.recyclingheroes.at/"
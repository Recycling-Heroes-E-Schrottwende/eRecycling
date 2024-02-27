import requests

class UserService:
    def __init__(self):
        self.url = "http://app.recyclingheroes.at/"

    def get_user_products(self, user_id):
        response = requests.get(self.url + f"user/{user_id}/products")
        return response.json()
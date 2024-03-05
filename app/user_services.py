import requests

class UserService:
    def __init__(self):
        self.url = "http://app.recyclingheroes.at/api/"

    def get_favourites(self):
        response = requests.get(self.url + "user/favourites/")
        if response.status_code == 200:
            return response.json()
        else:
            return {'error': 'Failed to load favourite products'}, 404
from flask import Flask, jsonify
from flask_cors import CORS
from product_services import ProductService
#from user_services import UserService

class App:
    def __init__(self):
        self.app = Flask(__name__)
        CORS(self.app)

        self.product_service = ProductService()
        # self.user_service = UserService()

        self.initialize_routes()

    def initialize_routes(self):
        @self.app.route('/products')
        def products():
            return jsonify(self.product_service.get_products())

        @self.app.route('/product/<int:product_id>')
        def product_detail(product_id):
            return jsonify(self.product_service.get_product_by_id(product_id))

        @self.app.route('/image/<int:product_id>')
        def product_image(product_id):
            return jsonify(self.product_service.get_image(product_id))

if __name__ == '__main__':
    app_instance = App()
    app_instance.app.run(host='localhost', port=3830)

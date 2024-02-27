from flask import Flask, jsonify
from flask_cors import CORS
from product_services import ProductService
from user_services import UserService

class App:
    app = Flask(__name__)
    CORS(app)

    product_service = ProductService()
    user_service = UserService()

    @app.route('/products')
    def products():
        return jsonify(product_service.get_products())

    @app.route('/product/<int:product_id>')
    def product_detail(product_id):
        return jsonify(product_service.get_product_by_id(product_id))

    @app.route('/image/<int:product_id>')
    def product_image(product_id):
        return jsonify(product_service.get_image(product_id))

    @app.route('/user/<int:user_id>')
    def user_products(user_id):
        return jsonify(user_service.get_user_products(user_id))

if __name__ == '__main__':
    App.app.run(host='localhost', port=3829)
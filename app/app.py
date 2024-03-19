from flask import Flask, request, jsonify
from flask_cors import CORS
from product_services import ProductService
from user_services import UserService

# Define the Flask application
app = Flask(__name__)
CORS(app)

# Instantiate services
product_service = ProductService()
user_service = UserService()

# Define routes
@app.route('/products')
def products():
    return jsonify(product_service.get_products())

@app.route('/products/new')
def new_product():
    return jsonify(product_service.get_new_products())

@app.route('/product/<int:product_id>')
def product_detail(product_id):
    return jsonify(product_service.get_product_by_id(product_id))


@app.route('/create/product', methods=['POST'])
def create_product():
    title = request.form['title']
    desc = request.form['desc']
    category = request.form['category']
    condition = request.form['condition']
    delivery = request.form['delivery']
    postcode = request.form['postcode']
    price = request.form['price']

    return jsonify(product_service.post_product(title, desc, category, condition, delivery, postcode, price))

@app.route('/image/<int:product_id>')
def product_image(product_id):
    return product_service.get_image(product_id)

@app.route('/user/favourites')
def user_favourites():
    return jsonify(product_service.get_favourites())

if __name__ == '__main__':
    app.run(host='localhost', port=3833)

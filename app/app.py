from flask import Flask, jsonify
from flask_cors import CORS
from services import ProductService

app = Flask(__name__)
CORS(app)

product_service = ProductService()

@app.route('/products')
def products():
    return jsonify(product_service.get_products())

@app.route('/products/<int:product_id>')
def product_detail(product_id):
    return jsonify(product_service.get_product_by_id(product_id))

@app.route('/image/<int:product_id>')
def product_image(product_id):
    return jsonify(product_service.get_image(product_id))

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=3829)
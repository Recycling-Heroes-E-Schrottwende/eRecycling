from flask import Flask, jsonify
from flask_cors import CORS
import requests
import json

app = Flask(__name__)
CORS(app)

class Test:
  def __init__(self):
    self.url = "http://128.140.3.14:8000/"

  def get(self):
    #headers = {}
    res = requests.get(self.url + "products/")
    return res.json()

  def get_product_by_id(self, product_id):
        res = requests.get(self.url + f"products/?skip={-1+product_id}&limit={1}")
        if res.status_code == 200:
            return res.json()
        else:
            return {'error': 'Product not found or failed to load'}

  def get_image(self):
    res = requests.get(self.url + "images/image_location?skip=0&limit=1")
    return res.json()

  def post(self):
    #headers = {}
    res = requests.post(self.url + "products/")
    return res.json()

test = Test()

@app.route('/products')
def index():
  return jsonify(test.get())

@app.route('/product/<int:product_id>')
def get_product(product_id):
    product_details = test.get_product_by_id(product_id)
    return jsonify(product_details)

@app.route('/image')
def image():
  image_list = test.get_image()
  image_path = image_list[0]
  return image_path

if __name__ == '__main__':
  app.run(debug=True, host='127.0.0.1', port=3829)
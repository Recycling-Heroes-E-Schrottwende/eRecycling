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

@app.route('/image')
def image():
  image_list = test.get_image()
  image_path = image_list[0]
  return image_path

if __name__ == '__main__':
  app.run(debug=True, host='127.0.0.1', port=3829)
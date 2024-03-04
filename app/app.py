from flask import Flask, request, jsonify
from flask_cors import CORS
from product_services import ProductService
from user_services import UserService

class App:
    def __init__(self):
        self.app = Flask(__name__)
        CORS(self.app)

        self.product_service = ProductService()
        self.user_service = UserService()

        self.initialize_routes()

    def initialize_routes(self):
        @self.app.route('/products')
        def products():
            return jsonify(self.product_service.get_products())

        @self.app.route('/products/new')
        def new_product():
            return jsonify(self.product_service.get_new_products())

        @self.app.route('/product/<int:product_id>')
        def product_detail(product_id):
            return jsonify(self.product_service.get_product_by_id(product_id))

        @self.app.route('/create/product', methods=['POST'])
        def create_product():
            title = request.form['title']
            desc = request.form['desc']
            image = request.files['image'] if 'image' in request.files else None
            print(image)

            if image:
                filename = secure_filename(image.filename)
                image.save(os.path.join("./uploads", filename))  # Speichert das Bild im Ordner "uploads"
        
            print("Title: ", title)
            print("Desc: ", desc)
            return jsonify({"message": "Produkt erfolgreich erstellt"}), 200
            #return jsonify(self.product_service.post_product(title, desc, image))

        @self.app.route('/image/<int:product_id>')
        def product_image(product_id):
            return jsonify(self.product_service.get_image(product_id))

        @self.app.route('/user/favourites')
        def user_favourites():
            return jsonify(self.user_service.get_favourites())

if __name__ == '__main__':
    app_instance = App()
    app_instance.app.run(host='localhost', port=3830)

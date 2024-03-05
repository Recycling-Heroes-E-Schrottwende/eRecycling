// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

const String serverUrl = 'http://app.recyclingheroes.at/flask-api';
//const String serverUrl = 'http://localhost:3833';

Future<List<Map<String, dynamic>>> fetch_products() async {
  final response = await http.get(Uri.parse('$serverUrl/products'));

  if (response.statusCode == 200) {
    List<dynamic> productsJson = jsonDecode(response.body);
    List<Map<String, dynamic>> products =
        List<Map<String, dynamic>>.from(productsJson);

    for (var product in products) {
      int productId = product['id'];
      String imageUrl = await fetch_image(productId);
      product['image_url'] = imageUrl;
    }

    return products;
  } else {
    if (response.body.contains('error')) {
      throw Exception(
          'Fehler beim Laden der Daten. Bitte versuchen Sie es später erneut.');
    } else {
      throw Exception('Failed to load data');
    }
  }
}

Future<String> fetch_image(int productId) async {
  final response = await http.get(Uri.parse('$serverUrl/image/$productId'));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception(
        'Failed to load image with status code: ${response.statusCode}');
  }
}

Future<List<Map<String, dynamic>>> fetch_newest_products() async {
  final response = await http.get(Uri.parse('$serverUrl/products/new'));

  if (response.statusCode == 200) {
    if (response.body.contains('error')) {
      throw Exception(
          'Fehler beim Laden der Daten. Bitte versuchen Sie es später erneut.');
    }
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<Map<String, dynamic>>> fetch_favourite_products() async {
  final response = await http.get(Uri.parse('$serverUrl/user/favourites'));

  if (response.statusCode == 200) {
    if (response.body.contains('error')) {
      throw Exception(
          'Fehler beim Laden der Daten. Bitte versuchen Sie es später erneut.');
    }
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

Future<String> fetch_imagelink(int productId) async {
  final response = await http.get(Uri.parse('$serverUrl/image/$productId'));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception(
        'Failed to load image link with status code: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> fetch_product_details(int productId) async {
  final response = await http.get(Uri.parse('$serverUrl/product/$productId'));

  if (response.statusCode == 200) {
    return Map<String, dynamic>.from(jsonDecode(response.body));
  } else {
    throw Exception(
        'Failed to load product details with status code: ${response.statusCode}');
  }
}

Future<void> create_product(String title, String desc, XFile? imageFile) async {
  var uri = Uri.parse('$serverUrl/create/product');
  var request = http.MultipartRequest('POST', uri)
    ..fields['title'] = title
    ..fields['desc'] = desc;
  if (imageFile != null) {
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));
  }
  var response = await request.send();

  if (response.statusCode == 200) {
    print('Produkt erfolgreich erstellt');
  } else {
    print('Fehler beim Erstellen des Produkts: ' + response.toString());
  }
}

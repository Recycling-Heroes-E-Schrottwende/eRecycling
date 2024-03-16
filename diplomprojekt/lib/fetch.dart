// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

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

Future<List<Map<String, dynamic>>> fetch_favourite_products() async {
  final response = await http.get(Uri.parse('$serverUrl/user/favourites'));

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

Future<void> create_product(String title, String desc, String category, String condition, String delivery, String postcode, String price) async {
  var uri = Uri.parse('$serverUrl/create/product');
  var request = http.MultipartRequest('POST', uri)
    ..fields['title'] = title
    ..fields['desc'] = desc
    ..fields['category'] = category
    ..fields['condition'] = condition
    ..fields['delivery'] = delivery
    ..fields['postcode'] = postcode
    ..fields['price'] = price;
  
  var response = await request.send();

  if (response.statusCode == 200) {
    print('Produkt erfolgreich erstellt');
  } else {
    print('Fehler beim Erstellen des Produkts: ' + response.toString());
  }
}

Future<void> uploadImage(File imageFile, int productId) async {
  // Erkennen des MIME-Typs des Bildes
  final mimeTypeData =
      lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])?.split('/');

  // Erstellen eines MultipartRequest
  var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'http://app.recyclingheroes.at/api/upload_image/?product_id=$productId'));

  // Hinzufügen des Bildes
  request.files.add(await http.MultipartFile.fromPath(
    'file',
    imageFile.path,
    contentType: MediaType.parse('${mimeTypeData![0]}/${mimeTypeData[1]}'),
  ));

  // Hinzufügen weiterer Felder, falls benötigt
  // request.fields['key'] = 'value';

  try {
    // Senden des Requests
    var streamedResponse = await request.send();

    // Empfangen der Antwort
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print("Bild erfolgreich hochgeladen!");
    } else {
      print("Fehler beim Hochladen des Bildes: ${response.body}");
    }
  } catch (e) {
    print("Ausnahme beim Hochladen des Bildes: $e");
  }
}

Future<List<String>> fetchImageUrls(int productId) async {
  final response = await http.get(Uri.parse(
      'http://app.recyclingheroes.at/api/picture_url/?product_id=$productId'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List<String> imageUrls = List<String>.from(data['url']);
    return imageUrls;
  } else {
    throw Exception('Failed to load image urls');
  }
}

// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:typed_data';

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

Future<void> create_product(
    String title,
    String desc,
    String category,
    String condition,
    String delivery,
    String postcode,
    String price,
    List<Uint8List> imageBytesList) async {
  var createProductUri = Uri.parse('$serverUrl/create/product');
  var createRequest = http.MultipartRequest('POST', createProductUri)
    ..fields['title'] = title
    ..fields['desc'] = desc
    ..fields['category'] = category
    ..fields['condition'] = condition
    ..fields['delivery'] = delivery
    ..fields['postcode'] = postcode
    ..fields['price'] = price;

  print(createRequest.fields);

  var createResponse = await createRequest.send();
  var createResponseBody = await http.Response.fromStream(createResponse);

  if (createResponse.statusCode == 200) {
    print('Produkt erfolgreich erstellt');

    // Abrufen der Produktliste, um die ID des zuletzt erstellten Produkts zu ermitteln
    var getProductsUri =
        Uri.parse('http://app.recyclingheroes.at/api/products/');
    var getProductsResponse = await http.get(getProductsUri);

    if (getProductsResponse.statusCode == 200) {
      var products = json.decode(getProductsResponse.body);
      if (products.isNotEmpty) {
        // Annahme: Die Produkte sind nach "created_at" absteigend sortiert
        var lastProduct = products.last;
        int productId = lastProduct['id'];

        // Bilder für das zuletzt erstellte Produkt hochladen
        await uploadImage(productId, imageBytesList);
      } else {
        print(
            'Keine Produkte gefunden, um die ID für den Bildupload zu erhalten');
      }
    } else {
      print(
          'Fehler beim Abrufen der Produkte: ${getProductsResponse.reasonPhrase}');
    }
  } else {
    print(
        'Fehler beim Erstellen des Produkts: ${createResponseBody.reasonPhrase}');
  }
}

Future<void> uploadImage(int productId, List<Uint8List> imageBytesList) async {
  var uri = Uri.parse(
      'http://app.recyclingheroes.at/api/uploadImage/?product_id=$productId');

  // Für jedes Bild in der Liste eine separate Anfrage erstellen und senden
  for (int i = 0; i < imageBytesList.length; i++) {
    var request = http.MultipartRequest('POST', uri);
    var image = imageBytesList[i];
    String fileName =
        'image_$i.png'; // Der Dateiname kann eindeutig generiert oder statisch sein

    // Fügt das Bild als Multipart-Datei hinzu
    request.files.add(http.MultipartFile.fromBytes(
      'file', // Der Name des Formularfeldes (muss mit der Servererwartung übereinstimmen)
      image,
      filename: fileName,
      contentType: MediaType('image', 'png'), // Setzt den MIME-Typ
    ));

    // Senden der Anfrage
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Bild $i erfolgreich hochgeladen');
    } else {
      // Ausgabe im Fehlerfall
      print('Fehler beim Hochladen des Bildes $i: ${response.reasonPhrase}');
    }
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

import 'package:http/http.dart' as http;
import 'dart:convert';

//const String serverUrl = 'http://app.recyclingheroes.at/flask-api';
const String serverUrl = 'http://localhost:3830';

Future<List<Map<String, dynamic>>> fetch_products() async {
  final response = await http.get(Uri.parse('$serverUrl/products'));
  

  if (response.statusCode == 200) {
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
    throw Exception('Failed to load product details with status code: ${response.statusCode}');
  }
}

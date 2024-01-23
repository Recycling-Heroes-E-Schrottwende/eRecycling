import 'package:flutter/material.dart';
import 'ProductPage.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl; // Hinzugefügt
  final int productId;

  const ProductCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl, // Hinzugefügt
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(imageUrl, fit: BoxFit.cover), // Verwende die statische URL
        title: Text(title),
        subtitle: Text(description),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(
                title: title,
                imagePath: imageUrl, // Statische URL hier auch verwenden
                productId: productId,
              ),
            ),
          );
        },
      ),
    );
  }
}

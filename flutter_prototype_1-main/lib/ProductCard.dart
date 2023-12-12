import 'package:flutter/material.dart';
import 'ProductPage.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String description;
  final Future<String> imagePathFuture;

  const ProductCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePathFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder<String>(
        future: imagePathFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return ListTile(
                title: Text(title),
                subtitle: Text(description),
                leading: Icon(Icons.error),
              );
            }
            return ListTile(
              leading: Image.asset(snapshot.data ?? ''),
              title: Text(title),
              subtitle: Text(description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductPage(title: title, imagePath: snapshot.data ?? ''),
                  ),
                );
              },
            );
          } else {
            // While waiting for the future to complete, show a loading indicator
            return ListTile(
              title: Text(title),
              subtitle: Text(description),
              leading: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

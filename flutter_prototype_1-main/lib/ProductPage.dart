import 'package:flutter/material.dart';
import 'fetch.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String imagePath;
  final int productId;

  const ProductPage({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetch_product_details(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Bild anzeigen
                    Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 250, // Festgelegte Höhe für das Bild
                    ),
                    // Textbereich für die Beschreibung
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['product_name'] ?? 'N/A',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Divider(),
                          Text('Beschreibung: ${data['description'] ?? 'N/A'}'),
                          Text('Zustand: ${data['condition'] ?? 'N/A'}'),
                          Text('Preis: \$${data['price']?.toStringAsFixed(2) ?? 'N/A'}'),
                          Text('Standort: ${data['location'] ?? 'N/A'}'),
                          Text('Postleitzahl: ${data['postcode'] ?? 'N/A'}'),
                          Text('Details: ${data['details'] ?? 'N/A'}'),
                          Text('Technische Details: ${data['technical_details'] ?? 'N/A'}'),
                          Text('Übergabe: ${data['transfer_method'] ?? 'N/A'}'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

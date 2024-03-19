import 'package:diplomprojekt/fetch.dart';
import 'package:diplomprojekt/pages/profile/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:diplomprojekt/flutter_flow/flutter_flow_theme.dart';
import 'ProductDetails.dart';

class OwnProductCard extends StatelessWidget {
  final int productId;
  final int postcode;
  final String title;
  final String imageUrl;
  final String description;
  final String condition;
  final String category;
  final double price;
  final VoidCallback onDelete;

  const OwnProductCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.productId,
    required this.postcode,
    required this.condition,
    required this.category,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailsWidget(
                    title: title,
                    postcode: postcode,
                    condition: condition,
                    imageUrl: imageUrl,
                    description: description,
                    category: category,
                    price: price,
                    productId: productId,
                  )),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            //color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 230,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 8,
                  child: deleteButton(
                      context), // Der rote Lösch-Button wird hier positioniert
                ),
                Positioned(
                  top: 0,
                  right: 50,
                  child: editButton(
                      context), // Der rote Lösch-Button wird hier positioniert
                ),
              ]),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: FlutterFlowTheme.of(context).bodyLarge,
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                      child: Text(
                        '${price.toStringAsFixed(2)} €',
                        style: FlutterFlowTheme.of(context).titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        description,
                        style: FlutterFlowTheme.of(context).labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget deleteButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, right: 8),
      decoration: BoxDecoration(
        color: Colors.red, // Roten Hintergrund für den Button
        borderRadius: BorderRadius.circular(5), // Abgerundete Ecken
      ),
      child: IconButton(
        icon: Icon(Icons.delete, color: Colors.white), // Weißes Mülleimer-Icon
        onPressed: () {
          // Bestätigungsdialog anzeigen
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Produkt löschen'),
                content: Text('Möchtest du dieses Produkt wirklich löschen?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Abbrechen'),
                    onPressed: () {
                      Navigator.of(context)
                          .pop(); // Schließt den Dialog ohne Aktion
                    },
                  ),
                  TextButton(
                    child: Text('Löschen', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      onDelete();
                      Navigator.of(context).pop(); // Schließt den Dialog
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget editButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, right: 8),
      decoration: BoxDecoration(
        color: Colors.orange, // Orangener Hintergrund für den Button
        borderRadius: BorderRadius.circular(5), // Abgerundete Ecken
      ),
      child: IconButton(
        icon: Icon(Icons.edit, color: Colors.white), // Weißes Stift-Icon
        onPressed: () {
          // Füge hier die Logik für die Bearbeitungsaktion ein
          // Zum Beispiel das Öffnen eines Dialogs oder einer neuen Seite zur Bearbeitung des Produkts
        },
      ),
    );
  }
}
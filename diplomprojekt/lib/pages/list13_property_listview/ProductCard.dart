import 'package:flutter/material.dart';
import 'package:diplomprojekt/flutter_flow/flutter_flow_theme.dart';
import 'ProductDetails.dart';

class ProductCard extends StatelessWidget {
  final int productId;
  final int postcode;
  final String title;
  final String imageUrl;
  final String description;
  final String condition;
  final String category;
  final String delivery;
  final double price;

  const ProductCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.productId,
    required this.postcode,
    required this.condition,
    required this.category,
    required this.delivery,
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
                    delivery: delivery,
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
                      child: Flexible(
                        child: Text(
                          '${price.toStringAsFixed(2)} €',
                          style: FlutterFlowTheme.of(context).titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
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
}

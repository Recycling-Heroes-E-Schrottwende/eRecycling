import 'package:diplomprojekt/pages/list13_property_listview/ProductCard.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'list13_property_listview_model.dart';
import '../../fetch.dart';
export 'list13_property_listview_model.dart';

class List13PropertyListviewWidget extends StatefulWidget {
  const List13PropertyListviewWidget({super.key});

  @override
  State<List13PropertyListviewWidget> createState() =>
      _List13PropertyListviewWidgetState();
}

class _List13PropertyListviewWidgetState
    extends State<List13PropertyListviewWidget>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<List13PropertyListviewWidget> {
  late List13PropertyListviewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => List13PropertyListviewModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return ProductCard(
        title: product['product_name'] ?? 'Unbekanntes Produkt',
        description: product['description'] ?? 'Keine Beschreibung verfügbar.',
        imageUrl: product['image_url'] ??
            'https://microsites.pearl.de/i/76/sd2208_5.jpg',
        productId: product['id'],
        price: product['price'].toDouble(),
        postcode: int.tryParse(product['postcode']) ?? 1190,
        condition: product['condition'],
        category: product['category']);
  }

  // ignore: non_constant_identifier_names
  Widget _error_message(var snapshot) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize
            .min, // Minimiert die Größe der Column basierend auf dem Inhalt
        children: [
          Icon(
            Icons.error_outline, // Icon, das einen Fehler anzeigt
            color: Colors.red[700], // Rote Farbe für das Fehlericon
            size: 50, // Größe des Icons
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 16), // Abstand zwischen Icon und Text
            child: Text(
              'Fehler beim Laden der Produkte', // Benutzerfreundliche Fehlermeldung
              style: TextStyle(
                fontSize: 18, // Schriftgröße
                color: Colors.red[700], // Textfarbe, passend zum Icon
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              "${snapshot.error}", // Technische Fehlermeldung
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    Colors.grey[600], // Farbe für die technische Fehlermeldung
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                child: Container(
                  width: double.infinity,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 3.0,
                        color: Color(0x33000000),
                        offset: Offset(0.0, 1.0),
                      )
                    ],
                    borderRadius: BorderRadius.circular(40.0),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).alternate,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 0.0, 12.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24.0,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                4.0, 0.0, 0.0, 0.0),
                            child: SizedBox(
                              width: 200.0,
                              child: TextFormField(
                                controller: _model.textController,
                                focusNode: _model.textFieldFocusNode,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Angebote durchsuchen...',
                                  labelStyle:
                                      FlutterFlowTheme.of(context).labelMedium,
                                  hintStyle:
                                      FlutterFlowTheme.of(context).labelMedium,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium,
                                cursorColor:
                                    FlutterFlowTheme.of(context).primary,
                                validator: _model.textControllerValidator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Align(
                      alignment: const Alignment(0.0, 0),
                      child: TabBar(
                        labelColor: FlutterFlowTheme.of(context).primaryText,
                        unselectedLabelColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        labelStyle: FlutterFlowTheme.of(context).labelSmall,
                        unselectedLabelStyle: const TextStyle(),
                        indicatorColor: const Color(0xFF387B2E),
                        padding: const EdgeInsets.all(4.0),
                        tabs: const [
                          Tab(
                            text: 'Homes',
                            icon: Icon(
                              Icons.home_filled,
                            ),
                          ),
                          Tab(
                            text: 'Neu Eingetroffen',
                            icon: Icon(
                              Icons.new_releases_sharp,
                            ),
                          ),
                          Tab(
                            text: 'Favoriten',
                            icon: Icon(
                              Icons.star,
                            ),
                          ),
                        ],
                        controller: _model.tabBarController,
                        onTap: (i) async {
                          [() async {}, () async {}, () async {}][i]();
                        },
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _model.tabBarController,
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    FutureBuilder<List<Map<String, dynamic>>>(
                                        future: fetch_products(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return _error_message(snapshot);
                                          } else if (snapshot.hasData) {
                                            return ListView.builder(
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              cacheExtent:
                                                  10, // Optimierung der Performance
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                return _buildProductCard(
                                                    snapshot.data![index]);
                                              },
                                            );
                                          } else {
                                            return const Center(
                                                child: Text(
                                                    'Keine Produkte gefunden'));
                                          }
                                        })
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ListView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    children: [
                                      FutureBuilder<List<Map<String, dynamic>>>(
                                          future: fetch_newest_products(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return _error_message(snapshot);
                                            } else if (snapshot.hasData) {
                                              return ListView.builder(
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                cacheExtent:
                                                    10, // Optimierung der Performance
                                                itemCount:
                                                    snapshot.data!.length,
                                                itemBuilder: (context, index) {
                                                  return _buildProductCard(
                                                      snapshot.data![index]);
                                                },
                                              );
                                            } else {
                                              return const Center(
                                                  child: Text(
                                                      'Keine Produkte gefunden'));
                                            }
                                          })
                                    ]),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    FutureBuilder<List<Map<String, dynamic>>>(
                                      future: fetch_favourite_products(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return _error_message(snapshot);
                                        } else if (snapshot.hasData) {
                                          return ListView.builder(
                                            physics:
                                                const AlwaysScrollableScrollPhysics(),
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            cacheExtent:
                                                10, // Optimierung der Performance
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) {
                                              return _buildProductCard(
                                                  snapshot.data![index]);
                                            },
                                          );
                                        } else {
                                          return const Center(
                                              child: Text(
                                                  'Keine Produkte gefunden'));
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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

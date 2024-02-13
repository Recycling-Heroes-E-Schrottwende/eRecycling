import 'package:flutter/material.dart';
import 'package:flutter_prototype_1/main_Chat.dart';
import 'package:google_fonts/google_fonts.dart';
// Hinweis: Stelle sicher, dass du die folgenden Pakete gemäß deinen Projektanforderungen importierst.
import 'fetch.dart';
import 'ProductCard.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycling Heroes',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: const IconThemeData(color: Colors.green),
          titleTextStyle: GoogleFonts.lato(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          elevation: 5,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.green[50],
          labelStyle: TextStyle(color: Colors.green[600]),
        ),
      ),
      initialRoute: '/chat',
      routes: {
        //'/': (context) => const HomeScreen(),
        '/chat': (context) => const MyApp2(),
        // Füge hier weitere Routen hinzu, falls nötig
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset('assets/images/logo.png'), // Stellen Sie sicher, dass das Logo-Bild vorhanden ist
        ),
        title: const Text('Recycling Heroes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Implementierung der Profilseiten-Navigation
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Suche',
                suffixIcon: Icon(Icons.search, color: Colors.green),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetch_products(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    return ListView(
                      children: snapshot.data!
                          .map((product) => ProductCard(
                                title: product['product_name'],
                                description: product['description'],
                                imageUrl: "https://heise.cloudimg.io/width/610/q85.png-lossy-85.webp-lossy-85.foil1/_www-heise-de_/imgs/18/3/6/2/7/3/4/9/urn-newsml-dpa-com-20090101-180117-99-674215_large_4_3-730e65d735747fae.jpeg",
                                productId: product['id'],
                              ))
                          .toList(),
                    );
                  } else {
                    return const Center(child: Text('Keine Produkte gefunden'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
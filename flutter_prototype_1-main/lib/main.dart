import 'package:flutter/material.dart';
import 'package:flutter_prototype_1/chat_/chat_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'fetch.dart';
import 'ProductCard.dart';
import 'chat_/chat_selection_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recycling Heroes', // Titel der App
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
      initialRoute: '/', // Startseite definieren
      routes: {
        '/': (context) => HomeScreen(), // Routen für die Startseite definieren
        '/chat': (context) => AuthScreen(), // Routen für den Chat definieren
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  Future<void> _register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'uid': userCredential.user?.uid,
        'username': _userNameController.text,
        'email': _emailController.text,
      });

      print('Registration successful: ${userCredential.user?.uid}');
    } catch (e) {
      print('Registration failed: $e');
    }
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print('Login successful: ${userCredential.user?.uid}');
      // Nach dem Login zur Hauptmenüseite navigieren
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainMenuScreen()),
      );
    } catch (e) {
      print('Login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Auth Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _register,
                  child: Text('Register'),
                ),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatSelectionScreen(),
              ),
            );
          },
          child: Text('Chat'),
        ),
      ),
    );
  }
}
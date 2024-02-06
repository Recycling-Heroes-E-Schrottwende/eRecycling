import 'package:chat_with_firebase/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
  
void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth Demo',
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    // Benutzer erfolgreich registriert, füge ihn zur "users"-Sammlung hinzu
    await FirebaseService_addUser().addUser(userCredential.user?.uid ?? '', _emailController.text);

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

class FirebaseService_addUser {
  Future<void> addUser(String userId, String username) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'username': username,
      });
    } catch (e) {
      print('Error adding user: $e');
    }
  }
}


class FirebaseService_getUser { //Userliste auslesen
  Future<List<String>> getAvailableUsers() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    List<String> userIds = querySnapshot.docs.map((doc) => doc.id).toList();
    return userIds;
  }
}


class MainMenuScreen extends StatelessWidget {
  String? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: FirebaseService_getUser().getAvailableUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<String> availableUsers = snapshot.data as List<String>;

                return DropdownButton<String>(
                  value: selectedUser,
                  onChanged: (newValue) {
                    selectedUser = newValue;
                  },
                  items: availableUsers.map((user) {
                    return DropdownMenuItem(
                      value: user,
                      child: Text(user),
                    );
                  }).toList(),
                );
              }
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedUser != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(receiverId: selectedUser!),
                  ),
                );
              }
            },
            child: Text('Chat'),
          ),
        ],
      ),
    );
  }
}
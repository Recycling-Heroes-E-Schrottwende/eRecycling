import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatSelectionScreen extends StatefulWidget {
  const ChatSelectionScreen({super.key});

  @override
  _ChatSelectionScreenState createState() => _ChatSelectionScreenState();
}

class _ChatSelectionScreenState extends State<ChatSelectionScreen> {
  List<Map<String, dynamic>> availableUsers = [];
  String selectedUserId = '';

  @override
  void initState() {
    super.initState();
    _fetchAvailableUsers();
  }

  Future<void> _fetchAvailableUsers() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();

      setState(() {
        availableUsers = querySnapshot.docs
          .where((doc) => doc.id != currentUserId) // Ausschluss des eigenen Benutzers
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a User'),
      ),
      body: ListView.builder(
        itemCount: availableUsers.length,
        itemBuilder: (context, index) {
          String username = availableUsers[index]['username'];

          return ListTile(
            title: Text(username),
            onTap: () {
              setState(() {
                selectedUserId = availableUsers[index]['uid'];
              });

              //Hier kannst du zusätzliche Aktionen durchführen, z.B. den Chat öffnen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(receiverId: selectedUserId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

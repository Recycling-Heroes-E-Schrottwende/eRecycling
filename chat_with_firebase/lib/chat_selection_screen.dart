import 'package:chat_with_firebase/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatSelectionScreen extends StatefulWidget {
  @override
  _ChatSelectionScreenState createState() => _ChatSelectionScreenState();
}

class _ChatSelectionScreenState extends State<ChatSelectionScreen> {
  List<String> availableUsers = [];
  String selectedUserId = '';

  @override
  void initState() {
    super.initState();
    _fetchAvailableUsers();
  }

  Future<void> _fetchAvailableUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();

      setState(() {
        availableUsers = querySnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a User'),
      ),
      body: ListView.builder(
        itemCount: availableUsers.length,
        itemBuilder: (context, index) {
          String userId = availableUsers[index];

          return ListTile(
            title: Text(userId),
            onTap: () {
              setState(() {
                selectedUserId = userId;
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

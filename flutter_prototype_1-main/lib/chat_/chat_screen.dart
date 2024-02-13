import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;

  ChatScreen({required this.receiverId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Private Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('chats')
                  .doc(_generateChatId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var messages = snapshot.data?.docs ?? [];
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  var text = message['text'];
                  var senderId = message['senderId'];

                  var messageWidget = MessageWidget(
                    text: text,
                    isMe: senderId == _auth.currentUser?.uid,
                  );
                  messageWidgets.add(messageWidget);
                }
                return ListView(
                  reverse: true,
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
  var user = _auth.currentUser;
  if (user != null) {
    var chatId = _generateChatId();
    var messageText = _messageController.text.trim();

    await _firestore
      .collection('chats')
      .doc(chatId)  // Hier wird ebenfalls die eindeutige Chatroom-ID verwendet
      .collection('messages')
      .add({
        'text': messageText,
        'senderId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

    _messageController.clear();
  }
}


  String _generateChatId() {
    var user = _auth.currentUser;
    var receiverId = widget.receiverId;
    var ids = [user?.uid, receiverId];
    ids.sort();
    return ids.join('_');
  }
}

class MessageWidget extends StatelessWidget {
  final String text;
  final bool isMe;

  MessageWidget({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Align(
        alignment: isMe ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

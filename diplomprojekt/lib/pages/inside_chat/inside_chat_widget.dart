import '/backend/backend.dart';
import '/flutter_flow/chat/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'inside_chat_model.dart';
export 'inside_chat_model.dart';

import 'package:firebase_auth/firebase_auth.dart';

class InsideChatWidget extends StatefulWidget {
  const InsideChatWidget({
    super.key,
    required this.users,
    this.chats,
  });

  final DocumentReference? chats;
  final String? users;

  @override
  State<InsideChatWidget> createState() => _InsideChatWidgetState();
}

class _InsideChatWidgetState extends State<InsideChatWidget> {
  late InsideChatModel _model;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InsideChatModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Color(0xFF81AC26),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pushNamed('chat');
            },
          ),
          title: Text(
            //'${widget.users}',
            'Nachrichten',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
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
        ),
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
          .doc(
              chatId) // Hier wird ebenfalls die eindeutige Chatroom-ID verwendet
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
    var receiverId = widget.users;
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

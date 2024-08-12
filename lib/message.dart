import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MessagesPage(),
    );
  }
}

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 65, 65, 65),
        title: Row(
          children: [
            Text(
              'Mensagens',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildMessagesList(),
          ),
          buildMessageInput(),
        ],
      ),
    );
  }

  Widget buildMessagesList() {
    return StreamBuilder(
      stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else {
          var messages = snapshot.data!.docs;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              var message = messages[index];
              var content = message['content'];
              var senderId = message['senderId'];
              var timestamp = message['timestamp'];

              return FutureBuilder(
                future: _getUsername(senderId),
                builder: (context, AsyncSnapshot<String> usernameSnapshot) {
                  var senderUsername = usernameSnapshot.data ?? 'Usuário Desconhecido';
                  var isCurrentUserMessage = senderId == _auth.currentUser?.uid;

                  return ListTile(
                    title: Text(content),
                    subtitle: Text('Enviado por: $senderUsername em ${_formatTimestamp(timestamp)}'),
                    trailing: isCurrentUserMessage
                        ? IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await _deleteMessage(message.id);
                            },
                          )
                        : null,
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  Widget buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Digite sua mensagem...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              await sendMessage();
            },
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  Future<String> _getUsername(String userId) async {
    var userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc.exists ? userDoc['username'] : '';
  }

  Future<void> sendMessage() async {
    var user = _auth.currentUser;
    if (user != null) {
      var content = _messageController.text.trim();
      if (content.isNotEmpty) {
        await _firestore.collection('messages').add({
          'content': content,
          'senderId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Limpar o campo de entrada após o envio
        _messageController.clear();
      }
    }
  }

  Future<void> _deleteMessage(String messageId) async {
    await _firestore.collection('messages').doc(messageId).delete();
  }
}
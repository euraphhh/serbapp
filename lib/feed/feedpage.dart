import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serb_app/widgets/navigation.dart';
import 'package:serb_app/message.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FeedPage(),
    );
  }
}

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  TextEditingController postController = TextEditingController();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserId = user.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('serb.png', width: 40, height: 40),
            ),
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessagesPage()));
              },
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.black87,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 100),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(137, 71, 71, 71),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: postController,
                      decoration: InputDecoration(
                        hintText: "O que você está pensando?",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String postText = postController.text;

                      if (postText.isNotEmpty && currentUserId != null) {
                        await FirebaseFirestore.instance.collection('posts').add({
                          'text': postText,
                          'userId': currentUserId,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        postController.clear();
                      } else {
                      }
                    },
                    child: Text("Postar"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return CircularProgressIndicator();
                  }
                  List<Widget> postWidgets = [];
                  final posts = snapshot.data!.docs;
                  for (var post in posts) {
                    final postText = post['text'];
                    final userId = post['userId'];
                    final postId = post.id;
                    bool isCurrentUserPost = currentUserId != null && userId == currentUserId;
                    postWidgets.add(
                      PostItem(
                        postText: postText,
                        postId: postId,
                        isCurrentUserPost: isCurrentUserPost,
                      ),
                    );
                  }
                  return ListView(children: postWidgets);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class PostItem extends StatelessWidget {
  final String postText;
  final String postId;
  final bool isCurrentUserPost;

  PostItem({required this.postText, required this.postId, required this.isCurrentUserPost});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder(
                future: _fetchUsername(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Text("Nome: ${snapshot.data}", style: TextStyle(color: Colors.white));
                    } else {
                      return Text("Nome: Desconhecido", style: TextStyle(color: Colors.white));
                    }
                  }
                  return Text("Nome: Carregando...", style: TextStyle(color: Colors.white));
                },
              ),
              if (isCurrentUserPost)
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white,),
                  onPressed: () {
                    if (isCurrentUserPost) {
                      // Exibir caixa de diálogo de confirmação
                      _showDeleteConfirmationDialog(context);
                    }
                  },
                ),
            ],
          ),
          Text(
            postText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.thumb_up, color: Colors.white),
                  Text("0", style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.comment,color: Colors.white),
                  Text("0", style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.share, color: Colors.white),
                  Text("0", style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String?> _fetchUsername() async {
    String? username;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc('yourUserId').get();
      if (doc.exists) {
        username = doc.data()!['username'];
      }
    } catch (e) {
      print("Erro ao buscar o nome de usuário: $e");
    }
    return username;
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Excluir Post"),
          content: Text("Tem certeza de que deseja excluir este post?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Excluir"),
              onPressed: () {
                // Excluir o post
                _deletePost(postId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePost(String postId) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
  }
}

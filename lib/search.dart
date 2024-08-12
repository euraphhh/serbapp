import 'package:flutter/material.dart';
import 'package:serb_app/profile.dart';
import 'widgets/navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/profile': (context) => ProfilePage(),
      },
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _currentIndex = 1; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 65, 65, 65),
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              icon: Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Pesquisa', 
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 49, 49, 49), Color.fromARGB(255, 49, 49, 49)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              
            ],
          ),
        ),
      ),
    bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

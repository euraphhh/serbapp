import 'package:flutter/material.dart';
import 'package:serb_app/feed/feedpage.dart';
import 'package:serb_app/feed/radar.dart';
import 'package:serb_app/profile.dart';
import 'package:serb_app/search.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Color.fromARGB(255, 14, 14, 14),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => FeedPage()),
                );
              },
              icon: Icon(
                Icons.home,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
              icon: Icon(
                Icons.search,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            const SizedBox(width: 24),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Radar()),
                );
              },
              icon: Icon(
                Icons.my_location,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              icon: Icon(
                Icons.person,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

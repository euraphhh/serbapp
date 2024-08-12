import 'package:flutter/material.dart';
import 'cadastro/Cadastro1.dart';
import 'LoginPage.dart';

void main() {
  runApp(SERBOnboardingApp());
}

class SERBOnboardingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202020),
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              OnboardingPage(
                title: 'Descubra a música',
                description: 'Explore um mundo com mais possibilidades.',
                image: 'assets/illustration1.png',
              ),
              OnboardingPage(
                title: 'Conecte-se com artistas',
                description: 'Colabore e conecte-se com novos artistas',
                image: 'assets/illustration2.png',
              ),
              OnboardingPage(
                title: 'Comece com a SERB',
                description: 'Crie uma conta ou faça login para iniciar.',
                image: 'assets/illustration3.png',
              ),
            ],
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
          Positioned(
            bottom: 30.0,
            right: 30.0,
            child: _currentPage != 2
                ? ElevatedButton(
                    onPressed: () {
                      
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    child: Text('Próximo'),
                  )
                : Container(), 
          ),
        ],
      ),
      bottomSheet: _currentPage == 2
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              width: double.infinity,
              color: Color(0xFF202020),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton('Criar conta', () {
                    
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Cadastro1(),
                      ),
                    );
                  }, Colors.blue),
                  SizedBox(height: 16.0),
                  _buildActionButton('Entre', () {
                    
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  }, Colors.black),
                ],
              ),
            )
          : null,
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < 3; i++) {
      indicators.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return indicators;
  }

  Widget _indicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Widget _buildActionButton(
      String text, VoidCallback onPressed, Color backgroundColor) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  OnboardingPage({required this.title, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          image,
          height: 200.0,
          width: 200.0,
        ),
        SizedBox(height: 30.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat', 
            color: Colors.white, 
          ),
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Montserrat', 
              color: Colors.white, 
            ),
          ),
        ),
      ],
    );
  }
}

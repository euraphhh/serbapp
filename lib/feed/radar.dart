import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serb_app/widgets/navigation.dart';

class Radar extends StatefulWidget {
  @override
  _RadarState createState() => _RadarState();
}

class _RadarState extends State<Radar> { 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, 
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 24),
            
            Container(
              height: 200, 
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/artista.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Artista da Semana',
              style: GoogleFonts.montserrat(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Nome do Artista',
              style: GoogleFonts.montserrat(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            CardWithTitle(
              title: 'Quem é o Artista?',
              onTap: () {
                _showArtistInfo(context);
              },
            ),
            CardWithTitle(
              title: 'Lançamento da Semana',
              onTap: () {
                _showSongInfo(context);
              },
            ),
            CardWithTitle(
              title: 'Playlist Radar: SERB',
              onTap: () {
                
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  void _showArtistInfo(BuildContext context) {
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ArtistInfoCard();
      },
    );
  }

  void _showSongInfo(BuildContext context) {
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SongInfoCard();
      },
    );
  }
}

class CardWithTitle extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  CardWithTitle({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListTile(
          title: Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}

class ArtistInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nome do Artista',
            style: GoogleFonts.montserrat(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text('Descrição do Artista'),
          
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text('Fechar'),
            ),
          ),
        ],
      ),
    );
  }
}

class SongInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nome da Música',
            style: GoogleFonts.montserrat(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text('Artista da Música'),
          
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); 
              },
              child: Text('Fechar'),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Radar(),
  ));
}

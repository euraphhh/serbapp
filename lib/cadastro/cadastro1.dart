import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'cadastro2.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MaterialApp(
    home: Cadastro1(),
  ));
}

class Cadastro1 extends StatefulWidget {
  @override
  _Cadastro1State createState() => _Cadastro1State();
}

class _Cadastro1State extends State<Cadastro1> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController nomeController = TextEditingController();
  bool isNomeValido = false;
  final RegExp nomeRegExp = RegExp(r"^[a-zA-Z\s]+$"); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            
            Positioned(
              top: 16.0,
              left: 16.0,
              child: Image.asset(
                'serb.png', 
                width: 100.0,
                height: 100.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 32.0),
                  Text(
                    'Vamos criar sua conta.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Qual o seu nome?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: nomeController,
                    onChanged: (value) {
                      setState(() {
                        isNomeValido = nomeRegExp.hasMatch(value) && value.length > 1;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Insira seu nome',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: isNomeValido
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cadastro2(nome: nomeController.text), 
                    ),
                  );
                  sendData();
                }
              : null,
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            shadowColor: Colors.black,
            elevation: 5,
          ),
          child: Text(
            'Próximo',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
    );
  }
  
  void sendData() {
    String id = Uuid().v1();
    db.collection("nome").doc(id).set({"nome": nomeController.text});
  }
}

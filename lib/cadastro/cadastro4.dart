import 'package:flutter/material.dart';
import 'cadastro_completo.dart';
import 'package:uuid/Uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cadastro4 extends StatefulWidget {
  final String nome;
  final String email;
  final String senha;

  Cadastro4({
    required this.nome,
    required this.email,
    required this.senha,
  });

  @override
  _Cadastro4State createState() => _Cadastro4State();
}

class _Cadastro4State extends State<Cadastro4> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController usernameController = TextEditingController();
  bool isUsernameValid = false;
  String usernameError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.black87,
            ),
            Positioned(
              top: 16.0,
              left: 16.0,
              child: Image.asset(
                'serb.png',
                width: 100.0,
                height: 100.0,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Falta pouco, ${widget.nome}!',
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
                      'Escolha um nome de usuário',
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
                      controller: usernameController,
                      onChanged: (value) async {
                        if (value.isNotEmpty) {
                          if (await isUsernameAvailable(value)) {
                            setState(() {
                              isUsernameValid = true;
                              usernameError = '';
                            });
                          } else {
                            setState(() {
                              isUsernameValid = false;
                              usernameError = 'Nome de usuário não está disponível';
                            });
                          }
                        } else {
                          setState(() {
                            isUsernameValid = false;
                            usernameError = 'Nome de usuário não pode ser vazio';
                          });
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Insira seu nome de usuário',
                        errorText: isUsernameValid ? null : usernameError,
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
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              right: 16.0,
              child: ElevatedButton(
                onPressed: isUsernameValid
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastroCompleto(
                              nome: widget.nome,
                              email: widget.email,
                              senha: widget.senha,
                              username: usernameController.text,
                            ),
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
                  'Concluir',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendData() {
    String id = Uuid().v1();
    db.collection("user").doc(id).set({"username": usernameController.text});
  }

  Future<bool> isUsernameAvailable(String username) async {
    // Consultar o Firestore para verificar a disponibilidade do username
    QuerySnapshot querySnapshot =
        await db.collection("user").where("username", isEqualTo: username).get();

    return querySnapshot.docs.isEmpty;
  }
}

import 'package:flutter/material.dart';
import 'cadastro3.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Cadastro2 extends StatefulWidget {
  final String nome;

  Cadastro2({required this.nome});

  @override
  _Cadastro2State createState() => _Cadastro2State();
}

class _Cadastro2State extends State<Cadastro2> {
  final TextEditingController emailController = TextEditingController();
  bool isEmailValido = false;
  bool emailJaRegistrado = false;

  Future<void> _verificarEmail() async {
    final email = emailController.text;

    if (!_validarEmail(email)) {
      // Email inválido, não continue
      return;
    }

    try {
      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (methods.isEmpty) {
        // O email não está registrado, continue
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Cadastro3(
              nome: widget.nome,
              email: email,
            ),
          ),
        );
      } else {
        // O email já está registrado, exiba uma mensagem
        setState(() {
          emailJaRegistrado = true;
        });
      }
    } catch (e) {
      print('Erro ao verificar o email: $e');
    }
  }

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
                      'Olá, ${widget.nome}!',
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
                      'Qual o seu email?',
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
                      controller: emailController,
                      onChanged: (value) {
                        setState(() {
                          isEmailValido = _validarEmail(value);
                          emailJaRegistrado = false;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Insira seu email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    if (emailJaRegistrado)
                      Text(
                        'Este email já está registrado!',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
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
                onPressed: isEmailValido
                    ? () {
                        _verificarEmail();
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
          ],
        ),
      ),
    );
  }

  bool _validarEmail(String email) {
    if (email.isEmpty) {
      return false;
    }
    final RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return regex.hasMatch(email);
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:serb_app/feed/feedpage.dart';

void main() {
  runApp(MaterialApp(
    home: CadastroCompleto(
      nome: "Nome do Usuário",
      email: "email@example.com",
      senha: "senha_segura",
      username: "username",
    ),
  ));
}

class CadastroCompleto extends StatefulWidget {
  final String nome;
  final String email;
  final String senha;
  final String username;

  CadastroCompleto({
    required this.nome,
    required this.email,
    required this.senha,
    required this.username,
  });

  @override
  _CadastroCompletoState createState() => _CadastroCompletoState();
}

class _CadastroCompletoState extends State<CadastroCompleto> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _cadastrarUsuario();
  }

  void _cadastrarUsuario() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.senha,
      );
      print('Usuário criado com sucesso');
    } catch (e) {
      print('Erro ao criar a conta: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 12, 12),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'illustration4.png',
                width: 200.0,
                height: 200.0,
              ),
              SizedBox(height: 32.0),
              Text(
                'Cadastro completo!',
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
                'Você pode ir para o feed agora.',
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
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedPage(
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                ),
                child: Text(
                  'Ir para o feed',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

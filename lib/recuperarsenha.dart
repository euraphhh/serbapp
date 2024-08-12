import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'feed/feedpage.dart';

class RecuperarSenha extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> enviarEmailRecuperacao(BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Um email de recuperação de senha foi enviado para ${emailController.text}'),
        ),
      );
    } catch (e) {
      print('Erro no envio de email de recuperação de senha: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocorreu um erro ao enviar o email de recuperação de senha. Verifique o email e tente novamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Senha'),
        backgroundColor: Colors.black54,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Digite o email da conta registrada para recuperar a senha:'),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(hintText: "Email"),
                controller: emailController,
              ),
            ),
            TextButton(
              onPressed: () {
                enviarEmailRecuperacao(context);
              },
              child: Text('Recuperar a senha'),
            ),
          ],
        ),
      ),
    );
  }
}
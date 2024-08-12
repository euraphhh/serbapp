import 'package:flutter/material.dart';
import 'package:serb_app/cadastro/cadastro_completo.dart';
import 'cadastro4.dart';

class Cadastro3 extends StatefulWidget {
  final String nome; 
  final String email; 

  Cadastro3({required this.nome, required this.email}); 

  @override
  _Cadastro3State createState() => _Cadastro3State();
}

class _Cadastro3State extends State<Cadastro3> {
  final TextEditingController senhaController = TextEditingController();
  double opacity = 0.0;
  bool isSenhaValida = false;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        opacity = 1.0;
      });
    });
  }


  void verificarSenha() {
    final senha = senhaController.text;
    setState(() {
      isSenhaValida =
          senha.isNotEmpty &&
          senha.length >= 6 &&
          senha.contains(RegExp(r'[A-Z]')) &&
          senha.contains(RegExp(r'[a-z]')) &&
          senha.contains(RegExp(r'[0-9]')) &&
          senha.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 12, 12), 
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            
            AnimatedOpacity(
              opacity: opacity, 
              duration: Duration(seconds: 1), 
              curve: Curves.easeIn, 
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                child: Image.asset(
                  'serb.png',
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: <Widget>[
                  SizedBox(height: 32.0),
                  Text(
                    'Crie sua senha.',
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
                    'Insira uma senha segura.',
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
                    controller: senhaController,
                    onChanged: (value) {
                      verificarSenha(); 
                    },
                    obscureText: true, 
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Digite sua senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      
                      suffixIcon: isSenhaValida
                          ? Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            ),
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                 
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'A senha deve conter no mínimo 6 caracteres, incluindo pelo menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.center,
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
          onPressed: isSenhaValida
              ? () {
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cadastro4(
                        nome: widget.nome, 
                        email: widget.email, 
                        senha: senhaController.text, 
                      ),
                    ),
                  );
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
}

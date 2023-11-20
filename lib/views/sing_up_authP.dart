import 'package:flutter/material.dart';
import 'package:sys_gestion/user_auth/firebase_auth_services.dart';
import 'package:sys_gestion/views/login_page.dart';

class SignUpPagep extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuthService _signUpAuth = FirebaseAuthService();
  final TextEditingController userTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: userTypeController,
              decoration: InputDecoration(
                labelText: 'Tipo de usuario (Padre de Familia)',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () => _register(context),
              child: Text('Registrarse'),
            ),
            SizedBox(height: 20,),

            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Ya tienes una cuenta?"),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "iniciar sesion",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            // Resto del código...
          ],
        ),
      ),
    );
  }

  void _register(BuildContext context) async {
    String? email = emailController.text;
    String? password = passwordController.text;
    String? userType = userTypeController.text.toLowerCase();

    if (email != null && password != null && userType == 'padre de familia') {
      String? userId = await _signUpAuth.signUpWithEmailAndPassword(email, password, userType);

      if (userId != null) {
         Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
        print('Usuario registrado como Padre de Familia con UID: $userId');
      } else {
        print('Error en el registro');
      }
    } else {
      print('Debe registrarse como Padre de Familia');
    }
  }
}

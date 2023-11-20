import 'package:flutter/material.dart';
import 'package:sys_gestion/user_auth/firebase_auth_services.dart';
import 'package:sys_gestion/views/login_page.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuthService _signUpAuth = FirebaseAuthService();

  // Agrega un controlador para el campo de tipo de usuario (docente o estudiante)
  final TextEditingController userTypeController = TextEditingController();

  void _register(BuildContext context) async {
    String? email = emailController.text;
    String? password = passwordController.text;
    String? userType = userTypeController.text.toLowerCase(); // Obtén el tipo de usuario ingresado

    if (email != null && password != null && userType == 'docente') {
      String? userId =
          await _signUpAuth.signUpWithEmailAndPassword(email, password, userType);

      if (userId != null) {
       Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
        // Registro exitoso, puedes redirigir a otra pantalla o manejar la lógica aquí
        print('Usuario registrado con UID: $userId');
        
      } else {
        // Manejar errores de registro aquí
        print('Error en el registro');
      }
    } else {
      // Manejar el caso donde el tipo de usuario no es un docente
      print('Debe ser un docente para registrarse');
    }
  }

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
                labelText: 'Tipo de usuario (Docente)',
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
                const Text("¿Ya tienes una cuenta?"),
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
                    "Iniciar sesión",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

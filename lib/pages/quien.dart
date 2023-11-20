import 'package:flutter/material.dart';
import 'package:sys_gestion/views/login_page.dart';
import 'package:sys_gestion/views/sign_up_auth.dart';
import 'package:sys_gestion/views/sing_up_authP.dart';



class quienPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Selección de Usuario'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Cómo quieres Registrarte?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Separación entre texto y botones
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
                print('Seleccionaste Docentes');
              },
              child: Text('Docentes'),
            ),
            SizedBox(height: 20), // Separación entre botones
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPagep()),
                );
                print('Seleccionaste Padres de Familia');
              },
              child: Text('Padres de Familia'),
            ),
          ],
        ),
      ),
    );
  }
}

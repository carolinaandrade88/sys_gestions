import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sys_gestion/pages/alumno.dart';
import 'package:sys_gestion/pages/seccionP.dart';
import 'package:sys_gestion/views/login_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}
//REBECA
class _HomeState extends State<Home> {
  int _selectedDrawerItem = 0;

  _getDrawerItemWidget(int position) {
    switch (position) {
      case 1:
        return MyHomePage2(); // Reemplaza con tu página deseada
      // Agrega casos para otros elementos del drawer si es necesario
      default:
        return SizedBox(); // Retorna un widget vacío para el caso por defecto
    }
  }

  void _onSelectDrawerItem(int pos) {
    Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage2()));
    setState(() {
      _selectedDrawerItem = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text('Consulta de Datos del Estudiante'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
              child: Center(
                child: Text(
                  'MENÚ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                  ),
                ),
              ),
            ),
            Divider(color: Colors.red),
            ListTile(
              leading: Icon(Icons.arrow_forward),
              title: Text('Alumnos Registro'),
              onTap: () {
                _onSelectDrawerItem(1);
              },
            ),
            // Agrega más ListTile para otros elementos del drawer
            Divider(color: Colors.red),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Cerrar sesión'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Información de la Institución',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Nombre: Instituto Educativo XYZ',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Dirección: Calle Principal, Ciudad ABC',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Teléfono: +123 456 7890',
              style: TextStyle(fontSize: 18),
            ),
            // Agrega más detalles de la institución educativa aquí
          ],
        ),
      ),
    );
  }
}

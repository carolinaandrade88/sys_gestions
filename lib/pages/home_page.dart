
import 'package:sys_gestion/pages/alumno.dart';
import 'package:sys_gestion/pages/quien.dart';
import 'package:sys_gestion/pages/seccionD.dart';
import 'package:sys_gestion/views/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => homeState();
}

class homeState extends State<home> {
  int ItemDrawer = 0;

  _getDrawerItem(int position) {
    switch (position) {
      case 1:return HomePage();
      
    }
  }

  void _onSelectItemDrawer(int pos) {
    Navigator.pop(context);
    setState(() {
      ItemDrawer = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.purpleAccent,
        title: Text('APP GESTION DE ALUMNOSS'),

      ),
      //agregar un aimagen
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
                    fontSize:35,
                  ),
                ),
              ),
            ),
            Divider(color: Colors.red),
            ListTile(
                leading: Icon(Icons.arrow_forward),
                title: Text('Alumnos Registro'),
                onTap: () {
                  _onSelectItemDrawer(1);
                }),
            Divider(color: Colors.red),
            ListTile(
                leading: Icon(Icons.close),
                title: Text('Cerrar sesión'),
                onTap: () {
                  // FirebaseAuth.instance.signOut();
                 Navigator.pushReplacement(context,
             MaterialPageRoute(builder:(context)=> LoginPage()) );
                }),
          ],
        ),
      ),
      body:
      _getDrawerItem(ItemDrawer),



    );
  }
}

padresPage() {
}
import 'package:flutter/material.dart';
import 'package:sys_gestion/pages/alumno.dart';
import 'package:sys_gestion/pages/asistencias.dart';
import 'package:sys_gestion/pages/home_page.dart';
import 'package:sys_gestion/pages/tareas.dart';
// Reemplaza 'your_app' con el nombre de tu aplicación

class HomePage extends StatelessWidget {
  
//Comentario2
  HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Docente Dashboard'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
            child: Text('Notas del alumno'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>StudentTasksPage()),
              );
            },
            child: Text('Tareas del alumno'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentAttendancePage()),
              );
            },
            child: Text('Asistencia del alumno'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_gestion/pages/home2.dart';

void main() {
  runApp(MyApp());
}

class Estudiante {
  final String id;
  final String nombre;
  final int edad;
  final double nota1;
  final double nota2;
  final double nota3;
  final double nota4;
  final String resultado;

  Estudiante({
    required this.id,
    required this.nombre,
    required this.edad,
    required this.nota1,
    required this.nota2,
    required this.nota3,
    required this.nota4,
    required this.resultado,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage2(),
    );
  }
}

class MyHomePage2 extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage2> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _searchController = TextEditingController();
  List<Estudiante> estudiantes = [];
  List<Estudiante> estudiantesFiltrados = [];

  @override
  void initState() {
    super.initState();
    cargarEstudiantes();
  }

  Future<void> cargarEstudiantes() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('tb_estudiantes').get();
    setState(() {
      estudiantes = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Estudiante(
          id: doc.id,
          nombre: data['nombre'],
          edad: data['edad'],
          nota1: data['nota1'],
          nota2: data['nota2'],
          nota3: data['nota3'],
          nota4: data['nota4'],
          resultado: data['resultado'],
        );
      }).toList();
      estudiantesFiltrados = List.from(estudiantes);
    });
  }

  void filtrarEstudiantes(String query) {
    setState(() {
      estudiantesFiltrados = estudiantes.where((estudiante) {
        final nombre = estudiante.nombre.toLowerCase();
        final busqueda = query.toLowerCase();
        return nombre.contains(busqueda);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Búsqueda de estudiantes'),
      ),
      body:Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  filtrarEstudiantes(value);
                },
                decoration: InputDecoration(
                  labelText: 'Buscar por nombre',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Edad')),
                    DataColumn(label: Text('Nota 1')),
                    DataColumn(label: Text('Nota 2')),
                    DataColumn(label: Text('Nota 3')),
                    DataColumn(label: Text('Nota 4')),
                    DataColumn(label: Text('Promedio')),
                    DataColumn(label: Text('Resultado')),
                  ],
                  rows: estudiantesFiltrados
                      .map(
                        (estudiante) => DataRow(cells: [
                          DataCell(Text(estudiante.nombre)),
                          DataCell(Text(estudiante.edad.toString())),
                          DataCell(Text(estudiante.nota1.toString())),
                          DataCell(Text(estudiante.nota2.toString())),
                          DataCell(Text(estudiante.nota3.toString())),
                          DataCell(Text(estudiante.nota4.toString())),
                          DataCell(Text(
                              ((estudiante.nota1 +
                                          estudiante.nota2 +
                                          estudiante.nota3 +
                                          estudiante.nota4) /
                                      4)
                                  .toString())),
                          DataCell(Text(estudiante.resultado)),
                        ]),
                      )
                      .toList(),
                ),
                
              ),
              
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states){
                  return Colors.blue;
                  }),
                  shape: MaterialStateProperty.resolveWith((states){
                    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));
                    })
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: Text("Volver al Inicio"),
      
            
                
               
                
                ),
          ],
        ),
    );
  }
}

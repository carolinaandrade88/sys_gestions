import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
//CAMBIOS
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
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _nota1Controller = TextEditingController();
  final TextEditingController _nota2Controller = TextEditingController();
  final TextEditingController _nota3Controller = TextEditingController();
  final TextEditingController _nota4Controller = TextEditingController();

  List<Estudiante> estudiantes = [];

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
    });
  }

  Future<void> agregarEstudiante() async {
    String nombre = _nombreController.text;
    int edad = int.tryParse(_edadController.text) ?? 0;
    double nota1 = double.tryParse(_nota1Controller.text) ?? 0.0;
    double nota2 = double.tryParse(_nota2Controller.text) ?? 0.0;
    double nota3 = double.tryParse(_nota3Controller.text) ?? 0.0;
    double nota4 = double.tryParse(_nota4Controller.text) ?? 0.0;
    double promedio = (nota1 + nota2 + nota3 + nota4) / 4;
    String resultado = promedio >= 7.0 ? 'Aprobado' : 'Reprobado';

if (_nombreController.text == '' || _edadController.text == '') {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ingrese los datos del Alumno")));
  } else{
      try {
      DocumentReference ref = await _firestore.collection('tb_estudiantes').add({
        'nombre': nombre,
        'edad': edad,
        'nota1': nota1,
        'nota2': nota2,
        'nota3': nota3,
        'nota4': nota4,
        'resultado': resultado,
      });

      setState(() {
        estudiantes.add(Estudiante(
          id: ref.id,
          nombre: nombre,
          edad: edad,
          nota1: nota1,
          nota2: nota2,
          nota3: nota3,
          nota4: nota4,
          resultado: resultado,
        ));
        setState(() {
          _nombreController.clear();
          _edadController.clear();
          _nota1Controller.clear();
          _nota2Controller.clear();
          _nota3Controller.clear();
          _nota4Controller.clear();
        });
      });
    } catch (e) {
      print('Error al agregar estudiante: $e');
    }
  }
  }




   Future<void> eliminarEstudiante(String id) async {
    try {
      await _firestore.collection('tb_estudiantes').doc(id).delete();
      cargarEstudiantes();
    } catch (e) {
      print('Error al eliminar estudiante: $e');
    }
  }

   Future<void> editarNotasEstudiante(Estudiante estudiante) async {
    // Variables para el formulario de edición
    TextEditingController nota1Controller = TextEditingController(text: estudiante.nota1.toString());
    TextEditingController nota2Controller = TextEditingController(text: estudiante.nota2.toString());
    TextEditingController nota3Controller = TextEditingController(text: estudiante.nota3.toString());
    TextEditingController nota4Controller = TextEditingController(text: estudiante.nota4.toString());

    // Mostrar el formulario de edición
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar notas de ${estudiante.nombre}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nota1Controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Nota 1'),
                ),
                TextFormField(
                  controller: nota2Controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Nota 2'),
                ),
                TextFormField(
                  controller: nota3Controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Nota 3'),
                ),
                TextFormField(
                  controller: nota4Controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Nota 4'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Guardar los cambios en Firebase
                _guardarCambiosEstudiante(estudiante.id, {
                  'nota1': double.tryParse(nota1Controller.text) ?? estudiante.nota1,
                  'nota2': double.tryParse(nota2Controller.text) ?? estudiante.nota2,
                  'nota3': double.tryParse(nota3Controller.text) ?? estudiante.nota3,
                  'nota4': double.tryParse(nota4Controller.text) ?? estudiante.nota4,
                });
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _guardarCambiosEstudiante(String id, Map<String, dynamic> cambios) async {
    try {
      await _firestore.collection('tb_estudiantes').doc(id).update(cambios);
      cargarEstudiantes();
    } catch (e) {
      print('Error al guardar cambios: $e');
    }
  }

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de estudiantes'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _edadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Edad'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nota1Controller,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Nota 1'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _nota2Controller,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Nota 2'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _nota3Controller,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Nota 3'),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _nota4Controller,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Nota 4'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: agregarEstudiante,
                child: Text('Agregar estudiante'),
              ),
              SizedBox(height: 40),
              Center(
                child:Text('DATOS DE ESTUDIANTES')
              ),
                SizedBox(height: 40),
              
              estudiantes.isNotEmpty
                  ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(//Esta es la tabla donde aparece los datos de el estudiantes
                        columns: [
                          DataColumn(label: Text('Nombre')),
                          DataColumn(label: Text('Edad')),
                          DataColumn(label: Text('Promedio')),
                          DataColumn(label: Text('Resultado')),
                          DataColumn(label: Text('Acciones')),
                        ],
                        rows: estudiantes
                            .map(
                              (estudiante) => DataRow(cells: [//Aca se llaman los datos de la base de datos si quieren agragar otro solo agregan otra columna arriba y 
                              //Aqui agregan otro como esto //DataCell(Text(estudiante.nota1)), por ejemplo
                                DataCell(Text(estudiante.nombre)),
                                DataCell(Text(estudiante.edad.toString())),
                                DataCell(Text(
                                    ((estudiante.nota1 +
                                      estudiante.nota2 +
                                      estudiante.nota3 +
                                      estudiante.nota4) / 4).toString()//Este es el codigo para hacer la suma de las notas
                                      )
                                      ),
                                DataCell(Text(estudiante.resultado)),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                      onPressed: () {
                                        showDialog( //Este es el daologo que muestra las notas del estudiante
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Notas de ${estudiante.nombre}'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Nota 1: ${estudiante.nota1}'),
                                                  Text('Nota 2: ${estudiante.nota2}'),
                                                  Text('Nota 3: ${estudiante.nota3}'),
                                                  Text('Nota 4: ${estudiante.nota4}'),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Cerrar'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        editarNotasEstudiante(estudiante);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        eliminarEstudiante(estudiante.id);
                                      },
                                    )
                                  ],
                                )),
                              ]),
                            )
                            .toList(),
                      ),
                  )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

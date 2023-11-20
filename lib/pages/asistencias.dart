import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentAttendancePage extends StatefulWidget {
  @override
  _StudentAttendancePageState createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _studentNameController = TextEditingController();
  bool _isPresent = false;
  bool _hasPermission = false;

  Future<void> markAttendance(String studentName) async {
    try {
      // Registra la asistencia del estudiante en Firestore
      await _firestore.collection('attendance').add({
        'studentName': studentName,
        'isPresent': _isPresent, // Agrega el estado del checkbox de asistencia
        'hasPermission': _hasPermission, // Agrega el estado del checkbox de permiso
      });

      // Actualiza la interfaz si es necesario
      setState(() {
        _studentNameController.clear();
        _isPresent = false;
        _hasPermission = false;
        // Actualizacion
      });
    } catch (e) {
      print('Error al marcar la asistencia: $e');
    }
  }

  Future<void> deleteAttendance(String documentId) async {
    try {
      // Elimina el registro de asistencia de Firestore
      await _firestore.collection('attendance').doc(documentId).delete();

      // Actualiza la interfaz si es necesario
      setState(() {
        // Puedes agregar lógica aquí para mostrar un mensaje de éxito o actualizar la vista
      });
    } catch (e) {
      print('Error al eliminar el registro de asistencia: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Asistencia'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _studentNameController,
              decoration: InputDecoration(labelText: 'Nombre del estudiante'),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _isPresent,
                  onChanged: (value) {
                    setState(() {
                      _isPresent = value!;
                    });
                  },
                ),
                Text('Presente'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _hasPermission,
                  onChanged: (value) {
                    setState(() {
                      _hasPermission = value!;
                    });
                  },
                ),
                Text('Permiso de faltar'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String studentName = _studentNameController.text;
                if (studentName.isNotEmpty) {
                  markAttendance(studentName);
                  // Puedes agregar lógica adicional después de marcar la asistencia
                } else {
                  // Manejar el caso donde el nombre está vacío
                }
              },
              child: Text('Marcar Asistencia'),
            ),
            SizedBox(height: 20),
            Text('Registro de Asistencia', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('attendance').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<DataRow> rows = snapshot.data!.docs.map((document) {
                    final documentId = document.id;
                    final studentName = document['studentName'];
                    final isPresent = document['isPresent'] ?? false;
                    final hasPermission = document['hasPermission'] ?? false;

                    return DataRow(
                      cells: [
                        DataCell(Text(studentName)),
                        DataCell(Center(
                          child: Checkbox(
                            value: isPresent,
                            onChanged: null,
                          ),
                        )),
                        DataCell(Center(
                          child: Checkbox(
                            value: hasPermission,
                            onChanged: null,
                          ),
                        )),
                        DataCell(IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteAttendance(documentId);
                          },
                        )),
                      ],
                    );
                  }).toList();

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Nombre del estudiante')),
                        DataColumn(label: Text('Asistencia')),
                        DataColumn(label: Text('Permiso de faltar')),
                        DataColumn(label: Text('Eliminar')),
                      ],
                      rows: rows,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StudentAttendancePage(),
  ));
}

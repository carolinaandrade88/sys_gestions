import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentTasksPage extends StatefulWidget {
  @override
  _StudentTasksPageState createState() => _StudentTasksPageState();
}

class _StudentTasksPageState extends State<StudentTasksPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _taskNameController = TextEditingController();
  bool _hasPendingTasks = false;
  bool _isTaskCompleted = false;

  Future<void> markTasks(String studentName, String taskName) async {
    try {
      // Registra las tareas pendientes del estudiante en Firestore
      await _firestore.collection('tasks').add({
        'studentName': studentName,
        'taskName': taskName,
        'hasPendingTasks': _hasPendingTasks, // Agrega el estado del checkbox
        'isTaskCompleted': _isTaskCompleted, // Agrega el estado del checkbox de tarea completada
      });

      // Actualiza la interfaz si es necesario
      setState(() {
        _studentNameController.clear();
        _taskNameController.clear();
        _hasPendingTasks = false;
        _isTaskCompleted = false;
      });
    } catch (e) {
      print('Error al marcar las tareas: $e');
    }
  }

  Future<void> deleteTask(String documentId) async {
    try {
      // Elimina la tarea de Firestore
      await _firestore.collection('tasks').doc(documentId).delete();

      // Actualiza la interfaz si es necesario
      setState(() {
        // Puedes agregar lógica aquí para mostrar un mensaje de éxito o actualizar la vista
      });
    } catch (e) {
      print('Error al eliminar la tarea: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Tareas'),
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
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(labelText: 'Nombre de la tarea'),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _hasPendingTasks,
                  onChanged: (value) {
                    setState(() {
                      _hasPendingTasks = value!;
                    });
                  },
                ),
                Text('Tiene tareas pendientes'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _isTaskCompleted,
                  onChanged: (value) {
                    setState(() {
                      _isTaskCompleted = value!;
                    });
                  },
                ),
                Text('Tarea completada'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String studentName = _studentNameController.text;
                String taskName = _taskNameController.text;
                if (studentName.isNotEmpty && taskName.isNotEmpty) {
                  markTasks(studentName, taskName);
                  // Puedes agregar lógica adicional después de marcar las tareas
                } else {
                  // Manejar el caso donde el nombre está vacío
                }
              },
              child: Text('Marcar Tarea'),
            ),
            SizedBox(height: 20),
            Text('Registro de Tareas', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('tasks').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<DataRow> rows = snapshot.data!.docs.map((document) {
                    final documentId = document.id;
                    final studentName = document['studentName'];
                    final taskName = document['taskName'];
                    final hasPendingTasks = document['hasPendingTasks'] ?? false;
                    final isTaskCompleted = document['isTaskCompleted'] ?? false;

                    return DataRow(
                      cells: [
                        DataCell(Text(studentName)),
                        DataCell(Text(taskName)),
                        DataCell(Center(
                          child: Checkbox(
                            value: hasPendingTasks,
                            onChanged: null,
                          ),
                        )),
                        DataCell(Center(
                          child: Checkbox(
                            value: isTaskCompleted,
                            onChanged: null,
                          ),
                        )),
                        DataCell(IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteTask(documentId);
                          },
                        )),
                      ],
                    );
                  }).toList();

                  return SingleChildScrollView(
                    scrollDirection:Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Nombre del estudiante')),
                        DataColumn(label: Text('Nombre de la tarea')),
                        DataColumn(label: Text('Tareas pendientes')),
                        DataColumn(label: Text('Tarea completada')),
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
    home: StudentTasksPage(),
  ));
}

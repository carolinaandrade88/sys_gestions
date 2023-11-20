import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_gestion/modelos/mode_estudiantes.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> signUpWithEmailAndPassword(String email, String password, String userType) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await addUserType(userCredential.user!.uid, userType);
        return userCredential.user!.uid;
      }
      return null;
    } catch (e) {
      print('Error durante el registro: $e');
      return null;
    }
  }

  Future<void> agregarEstudiante(Estudiante estudiante) async {
    try {
      await FirebaseFirestore.instance.collection('tb_estudiantes').add(estudiante.toMap());
    } catch (e) {
      print('Error al agregar estudiante: $e');
    }
  }

  Future<void> addUserType(String userId, String userType) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'userType': userType,
      });
    } catch (e) {
      print('Error al agregar tipo de usuario: $e');
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user; // Retorna el usuario obtenido del UserCredential
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return null;
    }
  }

  // Resto de tus métodos...
}

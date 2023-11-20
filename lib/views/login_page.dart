import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sys_gestion/pages/alumno.dart';
import 'package:sys_gestion/pages/home2.dart';
import 'package:sys_gestion/pages/home_page.dart';
import 'package:sys_gestion/pages/quien.dart';
import 'package:sys_gestion/pages/seccionD.dart';
import 'package:sys_gestion/pages/seccionP.dart';
import 'package:sys_gestion/user_auth/firebase_auth_services.dart';
import 'package:sys_gestion/views/sign_up_auth.dart';
import 'package:sys_gestion/widget/input_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? mensaje;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => print('Has presionado el icono menu'),
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 50,
                ),
                _InputCustomized(
                  _emailController,
                  false,
                  'Correo electronico',
                  'E-mail',
                  TextInputType.emailAddress,
                  Icons.email,
                ),
                const SizedBox(
                  height: 50,
                ),
                InputWidget(
                  controller: _passwordController,
                  hintText: 'Contrasena',
                  isPasswordField: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    _signIn();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: const Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Color.fromARGB(255, 247, 247, 247),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("No tienes una cuenta?"),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => quienPage()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Registrarme",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
               
                const SizedBox(
                  height: 25,
                ),
                Text(
                  '$mensaje',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
  if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
    setState(() {
      mensaje = "Por favor completa todos los campos";
    });
  } else {
    User? user = await _auth.signInWithEmailAndPassword(
  _emailController.text,
  _passwordController.text,
);

    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((doc) {
        if (doc.exists) {
          String userTypes = doc['userType'];

          if (userTypes.contains('docente')) {
            print("Login Satisfactorio como Docente!!!");
            
            setState(() {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home()));
              mensaje = "";
            });
          } else if (userTypes.contains('padre de familia')) {
            print("Login Satisfactorio como Padre de Familia!!!");
            // Redirige a la página correspondiente para Padres de Familia
            // Agrega la lógica para la página de Padres de Familia aquí
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
            setState(() {
              mensaje = "";
            });
          } else {
            setState(() {
              mensaje = "No tienes permisos suficientes";
            });
          }
        } else {
          setState(() {
            mensaje = "Usuario no encontrado";
          });
        }
      }).catchError((e) {
        print("Error al obtener el usuario: $e");
      });
    } else {
      setState(() {
        mensaje = "No se encontró el usuario especificado";
      });
    }
  }
}



  Widget _InputCustomized(
    TextEditingController controller,
    bool isPassword,
    String hintText,
    String labelText,
    TextInputType inputType,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        controller: controller,
        keyboardType: inputType,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black45),
          suffixIcon: Icon(
            icon,
            color: Color.fromARGB(255, 230, 208, 9),
          ),
        ),
      ),
    );
  }
}

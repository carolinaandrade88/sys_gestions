class Estudiante {
  final String nombre;
  final int edad;
  final double nota1;
  final double nota2;
  final double nota3;
  final double nota4;
   final String resultado;

  Estudiante({
    required this.nombre,
    required this.edad,
    required this.nota1,
    required this.nota2,
    required this.nota3,
    required this.nota4,
     required this.resultado,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'edad': edad,
      'nota1': nota1,
      'nota2': nota2,
      'nota3': nota3,
      'nota4': nota4,
      'resultado': resultado,
    };
  }
}

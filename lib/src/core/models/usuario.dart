import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {

  String? id;
  final String nombre;
  final String apellido;
  final String nombreUsuario;
  final String email;
  String? contrasena;
  final String rol;
  final bool estadoVigente;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.nombreUsuario,
    required this.email,
    required this.contrasena,
    required this.rol,
    required this.estadoVigente
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'apellido': apellido,
    'nombreUsuario': nombreUsuario,
    'email': email,
    'rol': rol,
    'estadoVigente': estadoVigente
  };

  factory Usuario.desdeDocumentSnapshot(DocumentSnapshot document) {
    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return Usuario(
      id: data['id'], 
      nombre: data['nombre'], 
      apellido: data['apellido'], 
      nombreUsuario: data['nombreUsuario'], 
      email: data['email'], 
      contrasena: null, 
      rol: data['rol'], 
      estadoVigente: data['estadoVigente']
    );
  }

  factory Usuario.desdeMapa(Map<String, dynamic> data) {
    return Usuario(
      id: data['id'],
      nombre: data['nombre'],
      apellido: data['apellido'],
      nombreUsuario: data['nombreUsuario'],
      email: data['email'],
      contrasena: null,
      rol: data['rol'],
      estadoVigente: data['estadoVigente'],
    );
  }
}

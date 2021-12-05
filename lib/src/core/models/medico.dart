import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Medico {

  final String? id;
  final String nombre;
  final String numeroMatricula;
  final String titulo;
  final bool estadoVigente;
  DocumentReference? reference;

  Medico({
    this.id,
    required this.nombre,
    required this.numeroMatricula,
    required this.titulo,
    required this.estadoVigente,
    this.reference
  });

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'numeroMatricula': numeroMatricula,
    'titulo': titulo,
    'estadoVigente': estadoVigente,
  };

  Map<String, dynamic> toMapConId() => {
    'id': id,
    'nombre': nombre,
    'numeroMatricula': numeroMatricula,
    'titulo': titulo,
    'estadoVigente': estadoVigente
  };

  factory Medico.desdeMapInterno(Map<String, dynamic> data) => Medico(
    id: data['id'],
    nombre: data['nombre'],
    numeroMatricula: data['numeroMatricula'],
    titulo: data['titulo'],
    estadoVigente: data['estadoVigente'],
  );

  factory Medico.desdeDocumentSnapshot(DocumentSnapshot document) {
    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    
    return Medico(
      id: document.reference.id,
      nombre: data['nombre'],
      numeroMatricula: data['numeroMatricula'],
      titulo: data['titulo'],
      estadoVigente: data['estadoVigente'],
      reference: document.reference
    );
  }

  static TimeOfDay timeDesdeString(String tiempo) {
    final hora = tiempo.split(':').first;
    final minuto = tiempo.split(':').last;
    return TimeOfDay.fromDateTime(DateTime(0, 1, 1, int.parse(hora), int.parse(minuto), 0));
  }

  String timeAString(TimeOfDay time) {
    final hora = time.hour;
    final minuto = time.minute < 10
                    ? '0${time.minute}'
                    : time.minute;
    return '$hora$minuto';
  }
}
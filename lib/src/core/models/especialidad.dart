import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Especialidad {

  final String codigo;
  final String clasificacion;
  final TimeOfDay horaInicio;
  final TimeOfDay horaFinal;
  final int minutosAtencion;
  final bool estadoVigente;
  DocumentReference? reference;

  Especialidad({
    required this.codigo, 
    required this.clasificacion, 
    required this.horaInicio, 
    required this.horaFinal, 
    required this.minutosAtencion, 
    required this.estadoVigente,
    this.reference
  });

  Map<String, dynamic> toMap() => {
    'codigo': codigo,
    'clasificacion': clasificacion,
    'horaInicio': timeAString(horaInicio),
    'horaFinal': timeAString(horaFinal),
    'minutosAtencion': minutosAtencion,
    'estadoVigente': estadoVigente
  };

  factory Especialidad.desdeDocumentSnapshot(DocumentSnapshot document) {
    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    
    return Especialidad(
      codigo: data['codigo'],
      clasificacion: data['clasificacion'],
      horaInicio: timeDesdeString(data['horaInicio']),
      horaFinal: timeDesdeString(data['horaFinal']),
      minutosAtencion: data['minutosAtencion'],
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
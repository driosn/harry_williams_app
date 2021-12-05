import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/helpers/time_helper.dart';

class Especialidad {

  final String? id;
  final String codigo;
  final String clasificacion;
  final TimeOfDay horaInicio;
  final TimeOfDay horaFinal;
  final int minutosAtencion;
  final bool estadoVigente;
  DocumentReference? reference;

  Especialidad({
    this.id,
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
    'horaInicio': TimeHelper.aString(horaInicio),
    'horaFinal': TimeHelper.aString(horaFinal),
    'minutosAtencion': minutosAtencion,
    'estadoVigente': estadoVigente
  };

  Map<String, dynamic> toMapConId() => {
    'id': id,
    'codigo': codigo,
    'clasificacion': clasificacion,
    'horaInicio': TimeHelper.aString(horaInicio),
    'horaFinal': TimeHelper.aString(horaFinal),
    'minutosAtencion': minutosAtencion,
    'estadoVigente': estadoVigente
  };

  factory Especialidad.desdeMapa(Map<String, dynamic> data) {
    return Especialidad(
      id: data['id'],
      codigo: data['codigo'],
      clasificacion: data['clasificacion'],
      horaInicio: TimeHelper.desdeString(data['horaInicio']),
      horaFinal: TimeHelper.desdeString(data['horaFinal']),
      minutosAtencion: data['minutosAtencion'],
      estadoVigente: data['estadoVigente'],
    );
  }

  factory Especialidad.desdeDocumentSnapshot(DocumentSnapshot document) {
    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    
    return Especialidad(
      id: document.reference.id,
      codigo: data['codigo'],
      clasificacion: data['clasificacion'],
      horaInicio: TimeHelper.desdeString(data['horaInicio']),
      horaFinal: TimeHelper.desdeString(data['horaFinal']),
      minutosAtencion: data['minutosAtencion'],
      estadoVigente: data['estadoVigente'],
      reference: document.reference
    );
  }
}
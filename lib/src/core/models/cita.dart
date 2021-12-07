import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/models/medico.dart';
import 'package:harry_williams_app/src/core/models/usuario.dart';
import 'package:harry_williams_app/src/helpers/time_helper.dart';

import 'especialidad.dart';

class Cita {

  final String? id;
  final DateTime fecha;
  final TimeOfDay horaInicio;
  final TimeOfDay horaFin;
  final Medico medico;
  final Especialidad especialidad;
  Usuario paciente;
  final DocumentReference? reference;

  Cita({
    this.id,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.medico,
    required this.especialidad,
    required this.paciente,
    this.reference
  });

  Map<String, dynamic> toMap() => {
    'fecha': fecha,
    'horaInicio': TimeHelper.aString(horaInicio),
    'horaFin': TimeHelper.aString(horaFin),
    'medico': medico.toMapConId(),
    'paciente': paciente.toMap(),
    'especialidad': especialidad.toMapConId()
  };

  factory Cita.desdeMapa(Map<String, dynamic> data) {
    Timestamp fecha = data['fecha'];
    
    return Cita(
      fecha: fecha.toDate(),
      horaInicio: TimeHelper.desdeString(data['horaInicio']),
      horaFin: TimeHelper.desdeString(data['horaFin']),
      medico: Medico.desdeMapInterno(data['medico']),
      paciente: Usuario.desdeMapa(data['paciente']),
      especialidad: Especialidad.desdeMapa(data['especialidad']),
    );
  } 

  factory Cita.desdeDocumentSnapshot(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    Timestamp fecha = data['fecha'];
    
    return Cita(
      fecha: fecha.toDate(),
      horaInicio: TimeHelper.desdeString(data['horaInicio']),
      horaFin: TimeHelper.desdeString(data['horaFin']),
      medico: Medico.desdeMapInterno(data['medico']),
      paciente: Usuario.desdeMapa(data['paciente']),
      especialidad: Especialidad.desdeMapa(data['especialidad']),
      reference: document.reference
    );
  }
}

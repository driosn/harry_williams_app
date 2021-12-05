import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/models/dia.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/core/models/medico.dart';
import 'package:harry_williams_app/src/helpers/time_helper.dart';

class Programacion {

  final String? id;
  final Medico medico;
  final Especialidad especialidad;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final TimeOfDay horaInicio;
  final TimeOfDay horaFin;
  final List<Dia> dias;
  final int numeroFichas;
  final DocumentReference? reference;

  Programacion({
    this.id,
    required this.medico,
    required this.especialidad,
    required this.fechaInicio,
    required this.fechaFin,
    required this.horaInicio,
    required this.horaFin,
    required this.dias,
    required this.numeroFichas,
    this.reference
  });

  Map<String, dynamic> toMap() => {
    'medico': medico.toMapConId(),
    'especialidad': especialidad.toMapConId(),
    'fechaInicio': fechaInicio,
    'fechaFin': fechaFin,
    'horaInicio': TimeHelper.aString(horaInicio),
    'horaFin': TimeHelper.aString(horaFin),
    'dias': dias.map((dia) => dia.toMap()).toList(),
    'numeroFichas': numeroFichas
  };

  factory Programacion.desdeDocumentSnapshot(DocumentSnapshot document) {
    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final Timestamp fechaInicio = data['fechaInicio'];
    final Timestamp fechaFin = data['fechaFin'];
    return Programacion(
      id: document.reference.id,
      medico: Medico.desdeMapInterno(data['medico']),
      especialidad: Especialidad.desdeMapa(data['especialidad']),
      fechaInicio: fechaInicio.toDate(),
      fechaFin: fechaFin.toDate(),
      horaInicio: TimeHelper.desdeString(data['horaInicio']),
      horaFin: TimeHelper.desdeString(data['horaFin']),
      dias: Dia.desdeLista(data['dias']),
      numeroFichas: data['numeroFichas'],
      reference: document.reference
    );
  }
}
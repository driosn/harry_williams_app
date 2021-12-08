import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/models/medico.dart';

class Vacacion {
  final Medico medico;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final DocumentReference? reference;

  Vacacion({
    required this.medico,
    required this.fechaInicio,
    required this.fechaFin,
    this.reference
  });

  Map<String, dynamic> toMap() => {
    'medico': medico.toMapConId(),
    'fechaInicio': fechaInicio,
    'fechaFin': fechaFin
  };

  factory Vacacion.desdeDocumentSnapshot(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    Timestamp fechaInicio = data['fechaInicio'];
    Timestamp fechaFin = data['fechaFin'];
    
    return Vacacion(
      medico: Medico.desdeMapInterno(data['medico']),
      fechaInicio: fechaInicio.toDate(),
      fechaFin: fechaFin.toDate(),
      reference: document.reference
    );
  }
}
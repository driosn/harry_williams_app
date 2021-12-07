import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/models/cita.dart';

class CitaSolicitada {

  final Cita cita;
  final String estadoCita;
  final DateTime fecha;
  final DocumentReference? reference;

  CitaSolicitada({
    required this.cita,
    required this.estadoCita,
    required this.fecha,
    this.reference
  });

  Map<String, dynamic> toMap() => {
    'cita': cita.toMap(), 
    'estadoCita': estadoCita,
    'fecha': fecha 
  };

  factory CitaSolicitada.desdeDocumentSnapshot(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    Timestamp fecha = data['fecha'];

    return CitaSolicitada(
      cita: Cita.desdeMapa(data['cita']),
      estadoCita: data['estadoCita'],
      fecha: fecha.toDate(),
      reference: document.reference
    );
  }

}
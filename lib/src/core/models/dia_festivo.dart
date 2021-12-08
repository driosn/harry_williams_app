import 'package:cloud_firestore/cloud_firestore.dart';

class DiaFestivo {

  final String nombre;
  final DateTime fecha;
  final DocumentReference? reference;

  DiaFestivo({
    required this.nombre,
    required this.fecha,
    this.reference
  });

  Map<String, dynamic> toMap() => {
    'nombre': nombre,
    'fecha': fecha
  };

  factory DiaFestivo.desdeDocumentSnapshot(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;
    Timestamp fecha = data['fecha'];

    return DiaFestivo(
      nombre: data['nombre'], 
      fecha: fecha.toDate(),
      reference: document.reference
    );
  }

}
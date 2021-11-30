import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/core/models/medico.dart';

class MedicosBloc {

  static const _nombreColeccion = 'medicos';
  
  static final CollectionReference medicos = FirebaseFirestore.instance.collection(_nombreColeccion);

  Stream<List<Medico>> get medicosStream => medicos.snapshots().map<List<Medico>>((event) {
      return event.docs.map((item) {
        return Medico.desdeDocumentSnapshot(item);
      }).toList();
  });
}
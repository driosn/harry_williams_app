import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';

class EspecialidadesBloc {

  static const _nombreColeccion = 'especialidades';
  
  static final CollectionReference especialidades = FirebaseFirestore.instance.collection(_nombreColeccion);

  Stream<List<Especialidad>> get especialidadesStream => especialidades.snapshots().map<List<Especialidad>>((event) {
      return event.docs.map((item) {
        return Especialidad.desdeDocumentSnapshot(item);
      }).toList();
  });

  // Stream<List<Especialidad>> especialidadesStream() {
    // return especialidades.snapshots().map<List<Especialidad>>((event) {
      // return event.docs.map((item) {
        // return Especialidad.desdeDocumentSnapshot(item);
      // }).toList();
    // });
  // }
}
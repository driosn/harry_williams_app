import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/models/vacacion.dart';
import 'package:harry_williams_app/src/core/services/vacaciones_service.dart';

class VacacionesBloc {

  static const _nombreColeccion = 'vacaciones';
  final _vacacionesService = VacacionesService();
  
  static final CollectionReference vacaciones = FirebaseFirestore.instance.collection(_nombreColeccion);

  Stream<List<Vacacion>> get vacacionesStream => vacaciones.snapshots().map<List<Vacacion>>((event) {
      return event.docs.map((item) {
        return Vacacion.desdeDocumentSnapshot(item);
      }).toList();
  });

  Future<void> eliminar(Vacacion vacacion) async => await _vacacionesService.eliminar(vacacion);
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/core/services/especialidad_service.dart';

class EspecialidadesBloc {

  static const _nombreColeccion = 'especialidades';
  final _especialidadesService = EspecialidadService();
  
  static final CollectionReference especialidades = FirebaseFirestore.instance.collection(_nombreColeccion);

  Stream<List<Especialidad>> get especialidadesStream => especialidades.snapshots().map<List<Especialidad>>((event) {
      return event.docs.map((item) {
        return Especialidad.desdeDocumentSnapshot(item);
      }).toList();
  });

  Stream<List<Especialidad>> get especialidadesVigentesStream => especialidades.where('estadoVigente', isEqualTo: true).snapshots().map<List<Especialidad>>((event) {
    return event.docs.map((item) {
      return Especialidad.desdeDocumentSnapshot(item);
    }).toList();
  });

  void actualizarEstadoVigente(Especialidad especialidad) => _especialidadesService.actualizarEstadoVigente(especialidad);
  
  Future<void> eliminar(Especialidad especialidad) async => await _especialidadesService.eliminar(especialidad);
}
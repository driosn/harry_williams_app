import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/core/models/medico.dart';
import 'package:harry_williams_app/src/core/models/programacion.dart';
import 'package:harry_williams_app/src/core/services/especialidad_service.dart';
import 'package:harry_williams_app/src/core/services/medico_service.dart';
import 'package:harry_williams_app/src/core/services/programaciones_service.dart';
import 'package:rxdart/rxdart.dart';

class ProgramacionesBloc {

  final _programacionesService = ProgramacionesService();  

  final _programacionesController = BehaviorSubject<List<Programacion>>();

  static final CollectionReference programaciones = FirebaseFirestore.instance.collection('programaciones');
  Stream<List<Programacion>> get programacionesStream => programaciones.snapshots().map<List<Programacion>>((event) {
      return event.docs.map((item) {
        return Programacion.desdeDocumentSnapshot(item);
      }).toList();
  });

  void obtenerProgramaciones() async {
    final programacionesRespuesta = await _programacionesService.listar();
    _programacionesController.sink.add(programacionesRespuesta);
  }

  Future<void> eliminarProgramacion(Programacion programacion) async {
    await _programacionesService.eliminar(programacion);
    obtenerProgramaciones();
  }

  void dispose() {
    _programacionesController.close();
  }
}
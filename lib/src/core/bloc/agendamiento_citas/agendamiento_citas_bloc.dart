import 'package:harry_williams_app/src/core/models/programacion.dart';
import 'package:harry_williams_app/src/core/services/programaciones_service.dart';
import 'package:rxdart/rxdart.dart';

class AgendamientoCitasBloc {

  final _programacionesService = ProgramacionesService();

  final _programacionesController = BehaviorSubject<List<Programacion>>();

  Stream<List<Programacion>> get programacionesStream => _programacionesController.stream;

  void obtenerProgramacionesPorEspecialidadId(String id) async {
    final programacionesRespuesta = await _programacionesService.listarPorEspecialidadId(id);
    _programacionesController.sink.add(programacionesRespuesta);
  }

  void verificarExistenDisponiblesEnFecha(DateTime fecha) {
    
  }

  void dispose() {
    _programacionesController.close();
  }
}
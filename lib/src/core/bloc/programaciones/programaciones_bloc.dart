import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/core/models/medico.dart';
import 'package:harry_williams_app/src/core/services/especialidad_service.dart';
import 'package:harry_williams_app/src/core/services/medico_service.dart';
import 'package:rxdart/rxdart.dart';

class ProgramacionesBloc {

  final _especialidadesService = EspecialidadService();
  final _medicosService = MedicosService();

  final _especialidadesController = BehaviorSubject<List<Especialidad>>();
  final _medicosController = BehaviorSubject<List<Medico>>();

  Stream<List<Especialidad>> get especialidadesStream => _especialidadesController.stream;
  Stream<List<Medico>> get medicosStream => _medicosController.stream;

  void obtenerEspecialidades() async {
    final especialidadesRespuesta = await _especialidadesService.listar();
    _especialidadesController.sink.add(especialidadesRespuesta);
  }

  void obtenerMedicos() async {
    final medicosRespuesta = await _medicosService.listar();
    _medicosController.sink.add(medicosRespuesta);
  }

  void dispose() {
    _especialidadesController.close();
    _medicosController.close();
  }
}
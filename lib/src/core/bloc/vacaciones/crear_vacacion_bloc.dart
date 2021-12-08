import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/core/models/medico.dart';
import 'package:harry_williams_app/src/core/models/vacacion.dart';
import 'package:harry_williams_app/src/core/services/especialidad_service.dart';
import 'package:harry_williams_app/src/core/services/medico_service.dart';
import 'package:harry_williams_app/src/core/services/vacaciones_service.dart';
import 'package:rxdart/rxdart.dart';

class CrearVacacionBloc {

  final _medicosService = MedicosService();
  final _vacacionesService = VacacionesService();

  final _medicosController = BehaviorSubject<List<Medico>>();

  final _medicoController = BehaviorSubject<Medico>();
  final _fechaInicioController = BehaviorSubject<DateTime>();
  final _fechaFinController = BehaviorSubject<DateTime>();

  Stream<List<Medico>> get medicosStream => _medicosController.stream;
  Stream<Medico> get medicoStream => _medicoController.stream;
  Stream<DateTime> get fechaInicioStream => _fechaInicioController.stream;
  Stream<DateTime> get fechaFinStream => _fechaFinController.stream;

  Stream<bool> get formularioLlenadoCorrectamenteStream => Rx.combineLatest3(
    medicoStream, 
    fechaInicioStream,
    fechaFinStream,
    (Medico? medico, DateTime? fechaInicio, DateTime? fechaFin) {
      return (medico != null && fechaInicio != null && fechaFin != null);
    });

  set medico(Medico nuevoMedico) => _medicoController.sink.add(nuevoMedico);
  set fechaInicio(DateTime nuevaFechaInicio) => _fechaInicioController.sink.add(nuevaFechaInicio);
  set fechaFin(DateTime nuevaFechaFin) => _fechaFinController.sink.add(nuevaFechaFin);

  Medico get medico => _medicoController.valueOrNull!;
  DateTime get fechaInicio => _fechaInicioController.valueOrNull!;
  DateTime get fechaFin => _fechaFinController.valueOrNull!;

  void obtenerMedicos() async {
    final medicosResp = await _medicosService.listar();
    _medicosController.sink.add(medicosResp);
  }

  Future<void> crear() async {
    final _nuevaVacacion = Vacacion(
      medico: medico,
      fechaInicio: fechaInicio,
      fechaFin: fechaFin
    );
    await _vacacionesService.crear(_nuevaVacacion);
  }
}
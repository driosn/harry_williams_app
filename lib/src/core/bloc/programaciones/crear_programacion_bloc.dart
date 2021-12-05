import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/models/dia.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/core/models/medico.dart';
import 'package:harry_williams_app/src/core/models/programacion.dart';
import 'package:harry_williams_app/src/core/services/citas_service.dart';
import 'package:harry_williams_app/src/core/services/especialidad_service.dart';
import 'package:harry_williams_app/src/core/services/medico_service.dart';
import 'package:harry_williams_app/src/core/services/programaciones_service.dart';
import 'package:rxdart/rxdart.dart';

class CrearProgramacionBloc {

  final _programacionesService = ProgramacionesService();
  final _citasService = CitasService();
  final _especialidadesService = EspecialidadService();
  final _medicosService = MedicosService();

  final _especialidadesController = BehaviorSubject<List<Especialidad>>();
  final _medicosController = BehaviorSubject<List<Medico>>();
  final _diasController = BehaviorSubject<List<Dia>>();


  final _especialidadController = BehaviorSubject<Especialidad>();
  final _fechaInicioController = BehaviorSubject<DateTime>();
  final _fechaFinController = BehaviorSubject<DateTime>();
  final _diasSeleccionadosController = BehaviorSubject<List<Dia>>();
  final _numeroFichasController = BehaviorSubject<int>();
  final _horaInicioController = BehaviorSubject<TimeOfDay>();
  final _horaFinController = BehaviorSubject<TimeOfDay>();
  final _medicosSeleccionadosController = BehaviorSubject<List<Medico>>();

  final _estadoVigenteDefecto = true;

  Stream<List<Especialidad>> get especialidadesStream => _especialidadesController.stream;
  Stream<List<Medico>> get medicosStream => _medicosController.stream;
  Stream<List<Dia>> get diasStream => _diasController.stream;

  Stream<Especialidad> get especialidadStream => _especialidadController.stream;
  Stream<DateTime> get fechaInicioStream => _fechaInicioController.stream;
  Stream<DateTime> get fechaFinStream => _fechaFinController.stream;
  Stream<List<Dia>> get diasSeleccionadosStream => _diasSeleccionadosController.stream;
  Stream<int> get numeroFichasStream => _numeroFichasController.stream;
  Stream<TimeOfDay> get horaInicioStream => _horaInicioController.stream;
  Stream<TimeOfDay> get horaFinStream => _horaFinController.stream;
  Stream<List<Medico>> get medicosSeleccionadosStream => _medicosSeleccionadosController.stream;

  Stream<bool> get formularioLlenadoCorrectamenteStream => Rx.combineLatest8(
    especialidadStream,
    fechaInicioStream,
    fechaFinStream,
    diasSeleccionadosStream,
    numeroFichasStream,
    horaInicioStream,
    horaFinStream,
    medicosSeleccionadosStream,
    (Especialidad? especialidad, 
    DateTime? fechaInicio, 
    DateTime? fechaFin,
    List<Dia>? diasSeleccionados,
    int? numeroFichas,
    TimeOfDay? horaInicio,
    TimeOfDay? horaFin,
    List<Medico>? medicosSeleccionados) {
      return (especialidad != null
      && fechaInicio != null
      && fechaFin != null
      && diasSeleccionados != null && diasSeleccionados.isNotEmpty
      && numeroFichas != null && numeroFichas > 0
      && horaInicio != null
      && horaFin != null
      && medicosSeleccionados != null && medicosSeleccionados.isNotEmpty);
    }
  );

  set especialidad(Especialidad valor) => _especialidadController.sink.add(valor);
  set numeroFichas(int valor) => _numeroFichasController.sink.add(valor);
  set horaInicio(TimeOfDay valor) => _horaInicioController.sink.add(valor);
  set horaFin(TimeOfDay valor) => _horaFinController.sink.add(valor);
  set fechaInicio(DateTime valor) => _fechaInicioController.sink.add(valor);
  set fechaFin(DateTime valor) => _fechaFinController.sink.add(valor);

  void obtenerEspecialidades() async {
    final especialidadesRespuesta = await _especialidadesService.listar();
    _especialidadesController.sink.add(especialidadesRespuesta);
  }

  void obtenerMedicos() async {
    final medicosRespuesta = await _medicosService.listar();
    _medicosController.sink.add(medicosRespuesta);
  }

  void seleccionarDia(Dia dia) {
    if (_diasSeleccionadosController.valueOrNull != null) {
      if ( _diaEstaAgregadoASeleccionados(dia)) {
        _removerDia(dia);
      } else {
        _agregarDia(dia);
      }
    } else {
      _diasSeleccionadosController.sink.add([]);
      seleccionarDia(dia);
    }
  }

  bool _diaEstaAgregadoASeleccionados(Dia dia) => _diasSeleccionadosController.value.contains(dia);

  void _agregarDia(Dia dia) {
    final diasYaSeleccionados = _diasSeleccionadosController.value;
    diasYaSeleccionados.add(dia);
    _diasSeleccionadosController.sink.add(diasYaSeleccionados);
  }

  void _removerDia(Dia dia) {
    final diasYaSeleccionados = _diasSeleccionadosController.value;
    diasYaSeleccionados.remove(dia);
    _diasSeleccionadosController.sink.add(diasYaSeleccionados);
  }

  void seleccionarMedico(Medico medico) {
    if (_medicosSeleccionadosController.valueOrNull != null) {
      if (_medicoEstaAgregadoASeleccionados(medico)) {
        _removerMedico(medico);
      } else {
        _agregarMedico(medico);
      }
    } else {
      _medicosSeleccionadosController.sink.add([]);
      seleccionarMedico(medico);
    }
  }

  bool _medicoEstaAgregadoASeleccionados(Medico medico) => _medicosSeleccionadosController.value.contains(medico);

  void _agregarMedico(Medico medico) {
    final medicosYaSeleccionados = _medicosSeleccionadosController.value;
    medicosYaSeleccionados.add(medico);
    _medicosSeleccionadosController.sink.add(medicosYaSeleccionados);
  }

  void _removerMedico(Medico medico) {
    final medicosYaSeleccionados = _medicosSeleccionadosController.value;
    medicosYaSeleccionados.remove(medico);
    _medicosSeleccionadosController.sink.add(medicosYaSeleccionados);
  }

  void crear() async {
    List<Programacion> programacionesCreadasCorrectamente = [];
    try {

      List<Medico> medicosSeleccionados = _medicosSeleccionadosController.value;
      Especialidad especialidad = _especialidadController.value;
      DateTime fechaInicio = _fechaInicioController.value;
      DateTime fechaFin = _fechaFinController.value;
      TimeOfDay horaInicio = _horaInicioController.value;
      TimeOfDay horaFin = _horaFinController.value;
      int numeroFichas = _numeroFichasController.value;
      List<Dia> diasSeleccionados = _diasSeleccionadosController.value;
  
      for(int i = 0; i < medicosSeleccionados.length; i++) {
        final medico = medicosSeleccionados[i];
        Programacion nuevaProgramacion = Programacion(
          medico: medico,
          especialidad: especialidad,
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
          horaInicio: horaInicio,
          horaFin: horaFin,
          dias: diasSeleccionados,
          numeroFichas: numeroFichas
        );

        await _programacionesService.crear(nuevaProgramacion);
        programacionesCreadasCorrectamente.add(nuevaProgramacion);
      }
    } finally {
      for(int i = 0; i < programacionesCreadasCorrectamente.length; i++) {
        final programacion = programacionesCreadasCorrectamente[i];
        await _citasService.crearEnBaseAProgramacion(programacion);
      }
    }
  }

  void obtenerDias() async {
    _diasController.sink.add([
      Dia(id: 1, nombre: 'Lunes', nombreIngles: 'Monday'),
      Dia(id: 2, nombre: 'Martes', nombreIngles: 'Tuesday'),
      Dia(id: 3, nombre: 'Miercoles', nombreIngles: 'Wednesday'),
      Dia(id: 4, nombre: 'Jueves', nombreIngles: 'Thursday'),
      Dia(id: 5, nombre: 'Viernes', nombreIngles: 'Friday'),
      Dia(id: 6, nombre: 'Sabado', nombreIngles: 'Saturday'),
      Dia(id: 7, nombre: 'Domingo', nombreIngles: 'Sunday'),
    ]);
  }

  void dispose() {
    _especialidadesController.close();
    _medicosController.close();
    
    _especialidadController.close();
    _fechaInicioController.close();
    _fechaFinController.close();
    _diasController.close();
    _numeroFichasController.close();
    _horaInicioController.close();
    _horaFinController.close();
    _medicosSeleccionadosController.close();
  }

}
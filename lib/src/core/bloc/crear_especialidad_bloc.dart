import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/core/services/especialidad_service.dart';
import 'package:rxdart/rxdart.dart';

class CrearEspecialidadBloc {

  final _especialidadService = EspecialidadService();

  final _codigoController = BehaviorSubject<String>();
  final _clasificacionController = BehaviorSubject<String>();
  final _horaInicioController = BehaviorSubject<TimeOfDay>();
  final _horaFinalController = BehaviorSubject<TimeOfDay>();
  final _minutosAtencionController = BehaviorSubject<int>();

  Stream<String> get codigoStream => _codigoController.stream;
  Stream<String> get clasificacionStream => _clasificacionController.stream;
  Stream<TimeOfDay> get horaInicioStream => _horaInicioController.stream;
  Stream<TimeOfDay> get horaFinalStream => _horaFinalController.stream;
  Stream<int> get minutosAtencionStream => _minutosAtencionController.stream;

  Stream<bool> get formularioLlenadoCorrectamenteStream => Rx.combineLatest5(
    codigoStream, 
    clasificacionStream, 
    horaInicioStream, 
    horaFinalStream, 
    minutosAtencionStream, 
    (String? codigo, String? clasificacion, TimeOfDay? horaInicio, TimeOfDay? horaFin, int? minutosAtencion) {
      return (codigo != null && codigo.isNotEmpty
        && clasificacion != null && clasificacion.isNotEmpty
        && horaInicio != null
        && horaFin != null
        && minutosAtencion != null && minutosAtencion > 0);
    });

  set codigo(String nuevoCodigo) => _codigoController.sink.add(nuevoCodigo);
  set clasificacion(String nuevaClasificacion) => _clasificacionController.sink.add(nuevaClasificacion);
  set horaInicio(TimeOfDay nuevaHoraInicio) => _horaInicioController.sink.add(nuevaHoraInicio);
  set horaFinal(TimeOfDay nuevaHoraFin) => _horaFinalController.sink.add(nuevaHoraFin);
  set minutosAtencion(int nuevosMinutosAtencion) => _minutosAtencionController.sink.add(nuevosMinutosAtencion);

  String get codigo => _codigoController.valueOrNull!;
  String get clasificacion => _clasificacionController.valueOrNull!;
  TimeOfDay get horaInicio => _horaInicioController.valueOrNull!;
  TimeOfDay get horaFinal => _horaFinalController.valueOrNull!;
  int get minutosAtencion => _minutosAtencionController.valueOrNull!;

  final _estadoPorDefectoVigente = false;

  Future<void> crear() async {
    final _nuevaEspecialidad = Especialidad(
      codigo: codigo,
      clasificacion: clasificacion,
      horaInicio: horaInicio,
      horaFinal: horaFinal,
      minutosAtencion: minutosAtencion,
      estadoVigente: _estadoPorDefectoVigente
    );
    await _especialidadService.crear(_nuevaEspecialidad);
  }
}
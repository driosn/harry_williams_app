import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/core/services/especialidad_service.dart';
import 'package:rxdart/rxdart.dart';

class CrearEspecialidadBloc {

  final _especialidadService = EspecialidadService();

  final _codigoController = BehaviorSubject<String>();
  final _clasificacionController = BehaviorSubject<String>();

  Stream<String> get codigoStream => _codigoController.stream;
  Stream<String> get clasificacionStream => _clasificacionController.stream;

  Stream<bool> get formularioLlenadoCorrectamenteStream => Rx.combineLatest2(
    codigoStream, 
    clasificacionStream, 
    (String? codigo, String? clasificacion) {
      return (codigo != null && codigo.isNotEmpty
        && clasificacion != null && clasificacion.isNotEmpty);
    });

  set codigo(String nuevoCodigo) => _codigoController.sink.add(nuevoCodigo);
  set clasificacion(String nuevaClasificacion) => _clasificacionController.sink.add(nuevaClasificacion);

  String get codigo => _codigoController.valueOrNull!;
  String get clasificacion => _clasificacionController.valueOrNull!;

  final _estadoPorDefectoVigente = false;

  Future<void> crear() async {
    final _nuevaEspecialidad = Especialidad(
      codigo: codigo,
      clasificacion: clasificacion,
      estadoVigente: _estadoPorDefectoVigente
    );
    await _especialidadService.crear(_nuevaEspecialidad);
  }
}
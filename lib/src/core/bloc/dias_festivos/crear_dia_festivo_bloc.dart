import 'package:harry_williams_app/src/core/bloc/dias_festivos/dias_festivos_bloc.dart';
import 'package:harry_williams_app/src/core/models/dia_festivo.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/core/services/dias_festivos_service.dart';
import 'package:rxdart/rxdart.dart';

class CrearDiaFestivoBloc {

  final _diasFestivosService = DiasFestivosService();

  final _nombreController = BehaviorSubject<String>();
  final _fechaController = BehaviorSubject<DateTime>();

  Stream<String> get nombreStream => _nombreController.stream;
  Stream<DateTime> get fechaStream => _fechaController.stream;

  Stream<bool> get formularioLlenadoCorrectamenteStream => Rx.combineLatest2(
    nombreStream, 
    fechaStream,
    (String? nombre, DateTime? fecha) {
      return (nombre != null && nombre.isNotEmpty
        && fecha != null);
    });

  set nombre(String nuevoNombre) => _nombreController.sink.add(nuevoNombre);
  set fecha(DateTime nuevaFecha) => _fechaController.sink.add(nuevaFecha);

  String get nombre => _nombreController.valueOrNull!;
  DateTime get fecha => _fechaController.valueOrNull!;

  Future<void> crear() async {
    final _nuevoDiaFestivo = DiaFestivo(
      nombre: nombre,
      fecha: fecha
    );
    await _diasFestivosService.crear(_nuevoDiaFestivo);
  }
}
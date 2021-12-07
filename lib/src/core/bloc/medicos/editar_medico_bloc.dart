import 'package:harry_williams_app/src/core/models/medico.dart';
import 'package:harry_williams_app/src/core/services/medico_service.dart';
import 'package:rxdart/rxdart.dart';

class EditarMedicoBloc {

  final Medico medico;

  EditarMedicoBloc(this.medico) {
    nombre = medico.nombre;
    numeroMatricula = medico.numeroMatricula;
    titulo = medico.titulo;
  }

  final _medicoService = MedicosService();

  final _nombreController = BehaviorSubject<String>();
  final _numeroMatriculaController = BehaviorSubject<String>();
  final _tituloController = BehaviorSubject<String>();

  Stream<String> get nombreStream => _nombreController.stream;
  Stream<String> get numeroMatriculaStream => _numeroMatriculaController.stream;
  Stream<String> get tituloStream => _tituloController.stream;

  Stream<bool> get formularioLlenadoCorrectamenteStream => Rx.combineLatest3(
    nombreStream, 
    numeroMatriculaStream,
    tituloStream, 
    (String? nombre, String? numeroMatricula, String? titulo) {
      return (nombre != null && nombre.isNotEmpty
        && numeroMatricula != null && numeroMatricula.isNotEmpty
        && titulo != null && titulo.isNotEmpty);
    });

  set nombre(String nuevoNombre) => _nombreController.sink.add(nuevoNombre);
  set numeroMatricula(String nuevoNumeroMatricula) => _numeroMatriculaController.sink.add(nuevoNumeroMatricula);
  set titulo(String nuevoTitulo) => _tituloController.sink.add(nuevoTitulo);

  String get nombre => _nombreController.valueOrNull!;
  String get numeroMatricula => _numeroMatriculaController.valueOrNull!;
  String get titulo => _tituloController.valueOrNull!;

  Future<void> editar() async {
    final _medicoActualizado = Medico(
      nombre: nombre,
      numeroMatricula: numeroMatricula,
      titulo: titulo,
      estadoVigente: medico.estadoVigente,
      reference: medico.reference
    );
    await _medicoService.editar(_medicoActualizado);
  }
}
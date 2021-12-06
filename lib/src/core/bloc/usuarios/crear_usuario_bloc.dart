import 'package:harry_williams_app/src/core/models/usuario.dart';
import 'package:harry_williams_app/src/core/services/usuarios_service.dart';
import 'package:rxdart/rxdart.dart';

class CrearUsuarioBloc {

  final _usuariosService = UsuariosService();

  final _nombreController = BehaviorSubject<String>();
  final _apellidoController = BehaviorSubject<String>();
  final _nombreUsuarioController = BehaviorSubject<String>();
  final _correoController = BehaviorSubject<String>();
  final _contrasenaController = BehaviorSubject<String>();
  final _confirmacionContrasenaController = BehaviorSubject<String>();

  Stream<String> get nombreStream => _nombreController.stream;
  Stream<String> get apellidoStream => _apellidoController.stream;
  Stream<String> get nombreUsuarioStream => _nombreUsuarioController.stream;
  Stream<String> get correoStream => _correoController.stream;
  Stream<String> get contrasenaStream => _contrasenaController.stream;
  Stream<String> get confirmacionContrasenaStream => _confirmacionContrasenaController.stream;

  set nombre(String valor) => _nombreController.sink.add(valor);
  set apellido(String valor) => _apellidoController.sink.add(valor);
  set nombreUsuario(String valor) => _nombreUsuarioController.sink.add(valor);
  set correo(String valor) => _correoController.sink.add(valor);
  set contrasena(String valor) => _contrasenaController.sink.add(valor);
  set confirmacionContrasena(String valor) => _confirmacionContrasenaController.sink.add(valor);

  Stream<bool> get formularioLlenadoCorrectamenteStream => Rx.combineLatest6(
    nombreStream, 
    apellidoStream, 
    nombreUsuarioStream, 
    correoStream,
    contrasenaStream, 
    confirmacionContrasenaStream, 
    (String? a, String? b, String? c, String? d, String? e, String? f) {
      return (a != null && a.isNotEmpty
      && b != null && b.isNotEmpty
      && c != null && c.isNotEmpty
      && d != null && d.isNotEmpty
      && e != null && e.isNotEmpty && (e == f));
    });

  final _rolPaciente = "PAC";
  final _estadoVigenteDefecto = true;

  Future<void> crearPaciente() async {
    final nombre = _nombreController.value;
    final apellido = _apellidoController.value;
    final nombreUsuario = _nombreUsuarioController.value;
    final correo = _correoController.value;
    final contrasena = _contrasenaController.value;
    final nuevoUsuario = Usuario(
      id: null,
      nombre: nombre,
      apellido: apellido,
      nombreUsuario: nombreUsuario,
      email: correo,
      contrasena: contrasena,
      estadoVigente: _estadoVigenteDefecto,
      rol: _rolPaciente
    );

    await _usuariosService.registrarNuevo(nuevoUsuario);
  }
}
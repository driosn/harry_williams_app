import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/models/usuario.dart';
import 'package:harry_williams_app/src/core/services/usuarios_service.dart';
import 'package:rxdart/rxdart.dart';

class UsuarioBloc {
  static final _singleton = UsuarioBloc._();

  factory UsuarioBloc() => _singleton;
  UsuarioBloc._();

  final _usuariosService = UsuariosService();

  final _usuarioController = BehaviorSubject<Usuario>();
  final _correoLoginController = BehaviorSubject<String>();
  final _contrasenaLoginController = BehaviorSubject<String>();

  Stream<Usuario> get usuarioStream => _usuarioController.stream;
  Stream<String> get correoLoginStream => _correoLoginController.stream;
  Stream<String> get contrasenaLoginStream => _contrasenaLoginController.stream;

  Stream<bool> get formLoginLlenadoCorrectamenteSteram => Rx.combineLatest2(
    correoLoginStream, 
    contrasenaLoginStream, 
    (String? a, String? b) {
      return (a != null && a.isNotEmpty && b != null && b.isNotEmpty);
    }
  );

  set usuario(Usuario valor) => _usuarioController.sink.add(valor);
  set correoLogin(String valor) => _correoLoginController.sink.add(valor);
  set contrasenaLogin(String valor) => _contrasenaLoginController.sink.add(valor);

  Usuario get usuario => _usuarioController.value; 

  Future<Usuario> autenticarCorreoYContrasena() async {
    try {
      final correo = _correoLoginController.value;
      final contrasena = _contrasenaLoginController.value;
      Usuario usuarioAutenticado = await _usuariosService.autenticar(correo, contrasena);
      _usuarioController.sink.add(usuarioAutenticado);
      return usuarioAutenticado;
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    _usuarioController.close();
  }
}

UsuarioBloc usuarioBloc = UsuarioBloc();
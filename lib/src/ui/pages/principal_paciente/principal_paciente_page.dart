import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/bloc/usuarios/usuario_bloc.dart';
import 'package:harry_williams_app/src/ui/pages/agendamiento_citas/agendamiento_citas_especialidad_page.dart';

class PrincipalPacientePage extends StatelessWidget {
  PrincipalPacientePage({ Key? key }) : super(key: key);

  final _usuarioBloc = UsuarioBloc();

  @override
  Widget build(BuildContext context) {
    final usuario = _usuarioBloc.usuario;
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido: ${usuario.nombre}'),
      ),
      body: ListView(
        children: [
          _opcionItem(
            context, 
            titulo: 'Solicitar Cita Medica', 
            pageDestino: AgendamientoCitasEspecialidadPage()
          ),
        ],
      ),
    );
  }

  Widget _opcionItem(context, {
    required String titulo,
    required Widget pageDestino
  }) {
    return ListTile(
      title: Text(titulo),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        _irA(context, pageDestino);
      },
    );
  }

  void _irA(BuildContext context, Widget widgetDestino) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => widgetDestino
    ));
  }
}
import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/ui/pages/especialidades/especialidades_page.dart';
import 'package:harry_williams_app/src/ui/pages/medicos/medicos_page.dart';

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Principal'),
      ),
      body: ListView(
        children: [
          _opcionItem(context, titulo: 'Especialidades', pageDestino: EspecialidadesPage()),
          _opcionItem(context, titulo: 'Medicos', pageDestino: MedicosPage())

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
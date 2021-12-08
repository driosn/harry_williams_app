import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/ui/pages/citas_solicitadas_admin/citas_solicitadas_admin_page.dart';
import 'package:harry_williams_app/src/ui/pages/dias_festivos/dias_festivos_page.dart';
import 'package:harry_williams_app/src/ui/pages/especialidades/especialidades_page.dart';
import 'package:harry_williams_app/src/ui/pages/medicos/medicos_page.dart';
import 'package:harry_williams_app/src/ui/pages/programaciones/programaciones_page.dart';
import 'package:harry_williams_app/src/ui/pages/rendimiento/rendimiento_page.dart';
import 'package:harry_williams_app/src/ui/pages/vacaciones/vacaciones_page.dart';

class PrincipalPage extends StatelessWidget {
  const PrincipalPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: ListView(
        children: [
          _opcionItem(
            context, 
            titulo: 'Especialidades', 
            pageDestino: EspecialidadesPage()
          ),
          _opcionItem(
            context, 
            titulo: 'Medicos', 
            pageDestino: MedicosPage()
          ),
          _opcionItem(
            context, 
            titulo: 'Programaciones',
            pageDestino: ProgramacionesPage()
          ),
          _opcionItem(
            context, 
            titulo: 'Citas solicitadas',
            pageDestino: CitasSolicitadasAdminPage()
          ),
          _opcionItem(
            context,
            titulo: 'Vacaciones',
            pageDestino: VacacionesPage()
          ),
          _opcionItem(
            context, 
            titulo: 'Dias Festivos',
            pageDestino: DiasFestivosPage()
          ),
          _opcionItem(
            context, 
            titulo: 'Rendimiento',
            pageDestino: RendimientoPage()
          )
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
import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/bloc/especialidades/especialidades_bloc.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/ui/pages/agendamiento_citas/agendamiento_citas_medicos_page.dart';

class AgendamientoCitasEspecialidadPage extends StatelessWidget {
  AgendamientoCitasEspecialidadPage({ Key? key }) : super(key: key);

  final _especialidadesBloc = EspecialidadesBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seleccionar especialidad'
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Especialidad>>(
                stream: _especialidadesBloc.especialidadesVigentesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final especialidades = snapshot.data!;
                    if (especialidades.isNotEmpty) {
                      return ListView.builder(
                        itemCount: especialidades.length,
                        itemBuilder: (context, index) {
                          final especialidad = especialidades[index];
                          return ListTile(
                            title: Text(especialidad.clasificacion),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AgendamientoCitasMedicosPage(
                                    mEspecialidad: especialidad
                                  )
                                )
                              );
                            },
                          );
                        }
                      );
                    }
                    return Center(
                      child: Text(
                        'No existen especialidades disponibles en este momento'
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              ),
            )
          ],
        ),
      )
    );
  }
}
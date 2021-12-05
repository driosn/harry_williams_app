import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/bloc/agendamiento_citas/agendamiento_citas_bloc.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/core/models/programacion.dart';
import 'package:harry_williams_app/src/helpers/time_helper.dart';
import 'package:harry_williams_app/src/ui/pages/agendamiento_citas/agendamiento_citas_calendario_page.dart';
import 'package:harry_williams_app/src/ui/pages/programaciones/programaciones_page.dart';

class AgendamientoCitasMedicosPage extends StatefulWidget {
  final Especialidad mEspecialidad;  
  AgendamientoCitasMedicosPage({
    required this.mEspecialidad
  });

  @override
  State<AgendamientoCitasMedicosPage> createState() => _AgendamientoCitasMedicosPageState();
}

class _AgendamientoCitasMedicosPageState extends State<AgendamientoCitasMedicosPage> {
  
  final _agendamientoCitasBloc = AgendamientoCitasBloc();

  @override
  void initState() {
    _agendamientoCitasBloc.obtenerProgramacionesPorEspecialidadId(widget.mEspecialidad.id!);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar medico'),
      ),
      body: StreamBuilder<List<Programacion>>(
        stream: _agendamientoCitasBloc.programacionesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final programaciones = snapshot.data!;
            if (programaciones.isNotEmpty) {
              return ListView.builder(
                itemCount: programaciones.length,
                itemBuilder: (context, index) {
                  final programacion = programaciones[index];
                  final nombreMedico = programacion.medico.nombre.toUpperCase();
                  final horaInicio = TimeHelper.aString(programacion.horaInicio);
                  final horaFin = TimeHelper.aString(programacion.horaFin);
                  final String diasDeAtencion = programacion.dias.map((dia) => dia.nombre).join('-').toUpperCase();
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AgendamientoCitasCalendarioPage(
                            mProgramacion: programacion,
                          )
                        )
                      );
                    },
                    isThreeLine: true,
                    title: Text('Medico: $nombreMedico'),
                    subtitle: Text('Horario: $horaInicio - $horaFin\nDias de atención: $diasDeAtencion'),
                  );
                },
              );
            }
            return const Center(
              child: Text('No existen medicos para esta especialidad en este momento'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/bloc/citas_solicitadas/citas_solicitadas_bloc.dart';
import 'package:harry_williams_app/src/core/models/cita_solicitada.dart';
import 'package:harry_williams_app/src/core/services/citas_solicitadas_service.dart';
import 'package:harry_williams_app/src/helpers/time_helper.dart';
import 'package:harry_williams_app/src/utils/dialogs_carga.dart';
import 'package:intl/intl.dart';

class CitasSolicitadasAdminPage extends StatelessWidget {
  CitasSolicitadasAdminPage({ Key? key }) : super(key: key);

  final _citasSolicitadasBloc = CitasSolicitadasBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Citas solicitadas',
        ),
      ),
      body: StreamBuilder<List<CitaSolicitada>>(
        stream: _citasSolicitadasBloc.todasLasCitasSolicitadasStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final citas = snapshot.data!;
            if (citas.isNotEmpty) {
              return ListView.builder(
                itemCount: citas.length,
                itemBuilder: (context, index) {
                  final cita = citas[index];
                  final nombreEspecialidad = cita.cita.especialidad.clasificacion;
                  final nombreMedico = cita.cita.medico.nombre;
                  final fechaFormateada = DateFormat('dd/MM/yyyy').format(cita.cita.fecha);
                  final horaInicio = TimeHelper.aString(cita.cita.horaInicio);
                  final horaFin = TimeHelper.aString(cita.cita.horaFin);
                  return ListTile(
                    title: Text(
                      'Especialidad: $nombreEspecialidad'
                    ),
                    subtitle: Text(
                      'Médico: $nombreMedico\nHorario: $fechaFormateada, $horaInicio - $horaFin'
                    ),
                    isThreeLine: true,
                    leading: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 10
                      ),
                      decoration: BoxDecoration(
                        color: cita.estadoCita == 'agendada'
                          ? Colors.grey
                          : cita.estadoCita == 'cancelada'
                            ? Colors.red
                            : cita.estadoCita == 'sin_asistir'
                              ? Colors.blue
                              : Colors.green,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Text(
                        cita.estadoCita == 'agendada'
                          ? 'Agendada'
                          : cita.estadoCita == 'cancelada'
                            ? 'Cancelada'
                            : cita.estadoCita == 'sin_asistir'
                              ? 'Sin Asistir'
                              : 'Asistida',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      )
                    ),
                    trailing: PopupMenuButton<String>(
                      itemBuilder: (context) {
                        return <PopupMenuEntry<String>>[
                          const PopupMenuItem(
                            value: 'agendada',
                            child: Text('Agendada'),
                          ),
                          const PopupMenuItem(
                            value: 'sin_asistir',
                            child: Text('Sin Asistir')
                          ),
                          const PopupMenuItem(
                            value: 'cancelada',
                            child: Text('Cancelada')
                          ),
                          const PopupMenuItem(
                            value: 'asistida',
                            child: Text('Asistida')
                          )
                        ];
                      },
                      onSelected: (String estadoSeleccionado) async {
                        final _citasSolicitadasService = CitasSolicitadasService();
                        _citasSolicitadasService.cambiarEstadoAdmin(cita, estadoSeleccionado);
                      },
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator()
            );
          }
          return const Center(
            child: CircularProgressIndicator()
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/bloc/citas_solicitadas/citas_solicitadas_bloc.dart';
import 'package:harry_williams_app/src/core/models/cita_solicitada.dart';
import 'package:harry_williams_app/src/core/services/citas_service.dart';
import 'package:harry_williams_app/src/core/services/citas_solicitadas_service.dart';
import 'package:harry_williams_app/src/helpers/time_helper.dart';
import 'package:harry_williams_app/src/utils/dialogs_carga.dart';
import 'package:harry_williams_app/src/utils/toast.dart';
import 'package:intl/intl.dart';

class CitasSolicitadasPage extends StatelessWidget {
  CitasSolicitadasPage({ Key? key }) : super(key: key);

  final _citasSolicitadasBloc = CitasSolicitadasBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis citas solicitadas'),
      ),
      body: StreamBuilder<List<CitaSolicitada>>(
        stream: _citasSolicitadasBloc.misCitasSolicitadasStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final misCitas = snapshot.data!;
            if (misCitas.isNotEmpty) {
              return ListView.builder(
                itemCount: misCitas.length,
                itemBuilder: (context, index) {
                  final cita = misCitas[index];
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
                    trailing: cita.estadoCita == 'agendada'
                      ? IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.red.shade800,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: const Text('¿Está seguro de cancelar la cita solicitada?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('No'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: const Text('Si'),
                                      onPressed: () async {
                                        try {
                                          DialogsCarga.mostrarCircular(context);
                                          final _citasSolicitadasService = CitasSolicitadasService();
                                          _citasSolicitadasService.cancelar(cita);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Toast.mostrarCorrecto(mensaje: 'La cita se canceló correctamente');
                                        } catch (e) {
                                          Navigator.pop(context);
                                          print(e);
                                          Toast.mostrarIncorrecto(mensaje: 'La cita no se pudo cancelar');
                                        }
                                       },
                                    )
                                  ]
                                );
                              }
                            );
                          },
                        )
                      : cita.estadoCita == 'cancelada'
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 10
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: const Text(
                              'Cancelada',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            )
                          )
                        : cita.estadoCita == 'asistida'
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 10
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: const Text(
                                'Asistida',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              )
                            )
                          : Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 10
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: const Text(
                              'Sin Asistir',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            )
                          )
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
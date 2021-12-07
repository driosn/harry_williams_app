import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/bloc/usuarios/usuario_bloc.dart';
import 'package:harry_williams_app/src/core/models/cita.dart';
import 'package:harry_williams_app/src/core/models/cita_solicitada.dart';
import 'package:harry_williams_app/src/core/models/programacion.dart';
import 'package:harry_williams_app/src/core/services/citas_service.dart';
import 'package:harry_williams_app/src/core/services/citas_solicitadas_service.dart';
import 'package:harry_williams_app/src/helpers/time_helper.dart';
import 'package:harry_williams_app/src/ui/colores/colores.dart';
import 'package:harry_williams_app/src/ui/pages/principal_paciente/principal_paciente_page.dart';
import 'package:harry_williams_app/src/utils/dialogs_carga.dart';
import 'package:harry_williams_app/src/utils/toast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AgendamientoCitasCalendarioPage extends StatefulWidget {
  
  final Programacion mProgramacion;
  
  AgendamientoCitasCalendarioPage({
    required this.mProgramacion
  });

  @override
  State<AgendamientoCitasCalendarioPage> createState() => _AgendamientoCitasCalendarioPageState();
}

class _AgendamientoCitasCalendarioPageState extends State<AgendamientoCitasCalendarioPage> {
  
  late DateTime fechaInicial;
  late DateTime fechaFinal;
  late List<DateTime> diasDeAtencion;

  @override
  void initState() {
    super.initState();
    diasDeAtencion = [];
    final fechaHoy = DateTime.now();
    fechaInicial = widget.mProgramacion.fechaInicio;
    fechaFinal = widget.mProgramacion.fechaFin;
    DateTime fechaIterador = fechaInicial;

    while(fechaIterador.isBefore(fechaFinal) || fechaIterador.isAtSameMomentAs(fechaFinal)) {
      final literalDiaFecha = DateFormat('EEEE').format(fechaIterador);
      if (widget.mProgramacion.dias.map((dia) => dia.nombreIngles).contains(literalDiaFecha)) {
        diasDeAtencion.add(fechaIterador);
      }
      fechaIterador = fechaIterador.add(const Duration(days: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Fecha'),
      ),
      body: SafeArea(
        child: SfDateRangePicker(
          onSelectionChanged: _onSelectionChanged,
          selectionColor: Colors.red.shade100,
          cellBuilder: (BuildContext context, DateRangePickerCellDetails details) {
            final fechaASerRenderizada = details.date;
            final esDiaDeAtencion = diasDeAtencion.contains(fechaASerRenderizada);
            return Container(
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      details.date.day.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: esDiaDeAtencion
                          ? FontWeight.bold
                          : FontWeight.normal
                      ),
                    ),
                    const SizedBox(height: 6),
                    esDiaDeAtencion
                    ? Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: colorPrimario,
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child: const Center(
                        child: Text(
                          'Verificar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,                              
                          ),
                        ),
                      ),
                    )
                      : Container()
                  ],
                ),
              );
          },
        ),
      )
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) async {
    final _citasService = CitasService();
    final especialidadId = widget.mProgramacion.especialidad.id!;
    final medicoId = widget.mProgramacion.medico.id!;
    final dia = args.value as DateTime;
    final totalCitas = await _citasService.listarPorEspecialidadMedicoDia(
      especialidadId, 
      medicoId, 
      dia
    );

    final citasDisponibles = totalCitas.where((cita) => cita.paciente.id == '-1').toList();
    if (citasDisponibles.isEmpty) {
      mostrarNoExistenCitasDisponibles();
    } else {
      mostrarCitasDisponibles(citasDisponibles, dia);
    }
  }

  void mostrarNoExistenCitasDisponibles() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            'No existen citas disponibles en la fecha seleccionada',
          ),
          actions: [
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],  
        );
      }
    );
  }

  void mostrarCitasDisponibles(List<Cita> citasDisponibles, DateTime fechaSeleccionada) {
    final medico = widget.mProgramacion.medico;
    final dias = widget.mProgramacion.dias;
    final diaSeleccionadoLiteral = dias.where((dia) => dia.nombreIngles == DateFormat('EEEE').format(fechaSeleccionada)).first.nombre;

    final dia = fechaSeleccionada.day;
    final mes = fechaSeleccionada.month;
    final anio = fechaSeleccionada.year;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Citas disponibles'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.only(
                top: 12
              ),
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  height: 4,
                  color: Colors.grey,
                  thickness: 1.5,
                ),
                itemCount: citasDisponibles.length,
                itemBuilder: (context, index) {
                  final cita = citasDisponibles[index];
                  final horaInicio = TimeHelper.aString(cita.horaInicio);
                  final horaFin = TimeHelper.aString(cita.horaFin);
                  return ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: const Text(
                              '¿Está seguro de reservar esta cita médica?',
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Cancelar'),
                                onPressed: () => Navigator.pop(context)
                              ),
                              TextButton(
                                child: const Text('Aceptar'),
                                onPressed: () async {
                                  try {
                                    DialogsCarga.mostrarCircular(context);
                                    final _citasService = CitasService();
                                    final _citasSolicitadasService = CitasSolicitadasService();
                                    await _citasService.agendarCitaAPaciente(cita, usuarioBloc.usuario);
                                    cita.paciente = usuarioBloc.usuario;
                                    
                                    final _nuevaCitaSolicitada = CitaSolicitada(
                                      cita: cita,
                                      estadoCita: 'agendado',
                                      fecha: DateTime.now()
                                    );

                                    await _citasSolicitadasService.crear(_nuevaCitaSolicitada);

                                    Navigator.pop(context);
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => PrincipalPacientePage()), (route) => false);
                                    Toast.mostrarCorrecto(mensaje: 'Cita solicitada correctamente');
                                    print('Cita Agendada correctamente');
                                  } catch (e) {
                                    print('Error: $e');
                                    rethrow;
                                  }
                                }
                              )
                            ],
                          );
                        }
                      );
                    },
                    title: Text('Medico: ${medico.nombre.toUpperCase()}'),
                    subtitle: Text('Fecha: $dia/$mes/$anio - $diaSeleccionadoLiteral\nHora: $horaInicio - $horaFin'),
                  );
                }
              ),
            ),
          ),  
        );
      }
    );
  }
}
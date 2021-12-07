import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/bloc/programaciones/crear_programacion_bloc.dart';
import 'package:harry_williams_app/src/core/models/dia.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/core/models/medico.dart';
import 'package:harry_williams_app/src/utils/dialogs_carga.dart';
import 'package:harry_williams_app/src/utils/toast.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CrearProgramacionPage extends StatefulWidget {
  const CrearProgramacionPage({ Key? key }) : super(key: key);

  @override
  State<CrearProgramacionPage> createState() => _CrearProgramacionPageState();
}

class _CrearProgramacionPageState extends State<CrearProgramacionPage> {
  final _crearProgramacionBloc = CrearProgramacionBloc();

  @override
  void initState() {
    super.initState();
    _crearProgramacionBloc.obtenerDias();
    _crearProgramacionBloc.obtenerEspecialidades();
    _crearProgramacionBloc.obtenerMedicos();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Programación'),
      ),
      body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 18,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seleccionar Especialidad',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  const SizedBox(height: 8),
                  StreamBuilder<List<Especialidad>>(
                    stream: _crearProgramacionBloc.especialidadesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final especialidades = snapshot.data!;
                        return StreamBuilder<Especialidad>(
                          stream: _crearProgramacionBloc.especialidadStream,
                          builder: (context, seleccionadaSnapshot) {
                            final especialidadSeleccionada = seleccionadaSnapshot.data;
                            return DropdownButton<Especialidad>(
                              items: especialidades.map((item) {
                                return DropdownMenuItem<Especialidad>(
                                  child: Text(item.clasificacion),
                                  value: item,
                                );
                              }).toList(),
                              value: especialidadSeleccionada,
                              onChanged: (valor) {
                                if (valor != null) {
                                  _crearProgramacionBloc.especialidad = valor;
                                }
                              },
                            );
                          },
                        );
                      }
                      return Text('Cargando Especialidades...');
                    },
                  ),
                  Text(
                    'Seleccionar fechas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  StreamBuilder<DateTime>(
                    stream: _crearProgramacionBloc.fechaInicioStream,
                    builder: (context, snapshot) {
                      final fechaInicio = snapshot.data;
                      String fechaInicioLiteral = "No seleccionado";
                      if (fechaInicio != null) {
                        fechaInicioLiteral = DateFormat('dd/MM/yyyy').format(fechaInicio);
                      }
                      return ListTile(
                        title: Text('Fecha Inicio'),
                        trailing: Text(fechaInicioLiteral),
                        onTap: () async {
                          final _nuevaFechaInicio = await showDatePicker(
                            context: context, 
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365))
                          );
                          if (_nuevaFechaInicio != null) {
                            _crearProgramacionBloc.fechaInicio = _nuevaFechaInicio;
                          }
                        },
                      );
                    }
                  ),
                  StreamBuilder<DateTime>(
                    stream: _crearProgramacionBloc.fechaFinStream,
                    builder: (context, snapshot) {
                      final fechaFin = snapshot.data;
                      String fechaFinLiteral = "No seleccionado";
                      if (fechaFin != null) {
                        fechaFinLiteral = DateFormat('dd/MM/yyyy').format(fechaFin);
                      }
                      return ListTile(
                        title: Text('Fecha Fin'),
                        trailing: Text(fechaFinLiteral),
                        onTap: () async {
                          final _nuevaFechaFin = await showDatePicker(
                            context: context, 
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365))
                          );
                          if (_nuevaFechaFin != null) {
                            _crearProgramacionBloc.fechaFin = _nuevaFechaFin;
                          }
                        },
                      );
                    }
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Seleccionar Dias',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  const SizedBox(height: 8),
                  StreamBuilder<List<Dia>>(
                    stream: _crearProgramacionBloc.diasStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final dias = snapshot.data!;
                        return StreamBuilder<List<Dia>>(
                          stream: _crearProgramacionBloc.diasSeleccionadosStream,
                          builder: (context, seleccionadosSnapshot) {
                            final diasSeleccionados = seleccionadosSnapshot.data ?? [];
                            return Wrap(
                              runSpacing: 6,
                              children: dias.map((dia) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 4
                                  ),
                                  child: _checkboxPersonalizadoDia(
                                    context, 
                                    dia: dia, 
                                    seleccionado: diasSeleccionados.contains(dia),
                                    onPressed: () => _crearProgramacionBloc.seleccionarDia(dia)
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        );
                      }
                      return Text('Cargando Dias');
                    }
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Numero Fichas',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (valor) {
                      if (int.tryParse(valor) != null) {
                        _crearProgramacionBloc.numeroFichas = int.parse(valor);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Seleccionar horas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  StreamBuilder<TimeOfDay>(
                    stream: _crearProgramacionBloc.horaInicioStream,
                    builder: (context, snapshot) {
                      final horaInicio = snapshot.data;
                      String horaInicioLiteral = "No seleccionado";
                      if (horaInicio != null) {
                        final hora = '${horaInicio.hour}';
                        final minuto = horaInicio.minute < 10
                                  ? '0${horaInicio.minute}'
                                  : '${horaInicio.minute}';
                        horaInicioLiteral = '$hora:$minuto';
                      }
                      return ListTile(
                        title: Text('Hora Inicio'),
                        trailing: Text(horaInicioLiteral),
                        onTap: () async {
                          final _nuevaHoraInicio = await showTimePicker(
                            context: context, 
                            initialTime: TimeOfDay.now()
                          );
                          if (_nuevaHoraInicio != null) {
                            _crearProgramacionBloc.horaInicio = _nuevaHoraInicio;
                          }
                        },
                      );
                    }
                  ),
                  StreamBuilder<TimeOfDay>(
                    stream: _crearProgramacionBloc.horaFinStream,
                    builder: (context, snapshot) {
                      final horaFin = snapshot.data;
                      String horaFinLiteral = "No seleccionado";
                      if (horaFin != null) {
                        final hora = '${horaFin.hour}';
                        final minuto = horaFin.minute < 10
                                  ? '0${horaFin.minute}'
                                  : '${horaFin.minute}';
                        horaFinLiteral = '$hora:$minuto';
                      }
                      return ListTile(
                        title: Text('Hora Fin'),
                        trailing: Text(horaFinLiteral),
                        onTap: () async {
                          final _nuevaHoraFin = await showTimePicker(
                            context: context, 
                            initialTime: TimeOfDay.now()
                          );
                          if (_nuevaHoraFin != null) {
                            _crearProgramacionBloc.horaFin = _nuevaHoraFin;
                          }
                        },
                      );
                    }
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Seleccionar Médicos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  StreamBuilder<List<Medico>>(
                    stream: _crearProgramacionBloc.medicosSeleccionadosStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final medicosSeleccionados = snapshot.data!;
                        if (medicosSeleccionados.isNotEmpty) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: medicosSeleccionados.map((medico) {
                              return ListTile(
                                title: Text(medico.nombre),
                                subtitle: Text(medico.titulo),
                                trailing: IconButton(
                                  onPressed: () => _crearProgramacionBloc.seleccionarMedico(medico),
                                  icon: const Icon(
                                    Icons.close, 
                                    color: Colors.red
                                  ),
                                ),
                              );
                            }).toList()
                          );
                        }
                        return Container();
                      }
                      return Container();
                    },
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: ElevatedButton(
                      child: Text('SELECCIONAR MEDICOS'),
                      onPressed: _mostrarSeleccionarMedicos
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: StreamBuilder<bool>(
                      stream: _crearProgramacionBloc.formularioLlenadoCorrectamenteStream,
                      builder: (context, snapshot) {
                        final botonActivo = snapshot.hasData && snapshot.data == true;
                        return ElevatedButton(
                          onPressed: botonActivo 
                            ? _crearProgramacion
                            : null,
                          child: const Text(
                            'Crear Programación'
                          )
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
          ),
    );
  }

  void _crearProgramacion() async {
    try {
      DialogsCarga.mostrarCircular(context);
      await _crearProgramacionBloc.crear();
      Navigator.pop(context);
      Navigator.pop(context);
      Toast.mostrarCorrecto(mensaje: 'Programación creada correctamente');
    } catch (e) {
      Navigator.pop(context);
      print(e);
      Toast.mostrarIncorrecto(mensaje: 'No se pudo crear la programación');
    }
  }    

  void _mostrarSeleccionarMedicos() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: Container(
            child: Column(
              children: [
                Text(
                  'Seleccionar Médicos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<Medico>>(
                    stream: _crearProgramacionBloc.medicosStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final medicos = snapshot.data!;
                        return StreamBuilder<List<Medico>>(
                          stream: _crearProgramacionBloc.medicosSeleccionadosStream,
                          builder: (context, seleccionadosSnapshot) {
                            final medicosSeleccionados = seleccionadosSnapshot.data ?? [];
                            return Wrap(
                              runSpacing: 6,
                              children: medicos.map((medico) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 4
                                  ),
                                  child: _checkboxPersonalizadoMedico(
                                    context, 
                                    medico: medico, 
                                    seleccionado: medicosSeleccionados.contains(medico),
                                    onPressed: () => _crearProgramacionBloc.seleccionarMedico(medico)
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        );
                      }
                      return Text('Cargando Medicos');
                    }
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context), 
                  child: Text('Cerrar')
                )
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _checkboxPersonalizadoMedico(context, {
    required Medico medico, 
    required bool seleccionado,
    required VoidCallback onPressed 
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 750),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6
        ),
        decoration: BoxDecoration(
          color: seleccionado
            ? Theme.of(context).primaryColor
            : Colors.white,
          border: Border.all(
            color: Theme.of(context).primaryColor
          )
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: double.infinity),
              Text(
                medico.nombre,
                style: TextStyle(
                  fontWeight: seleccionado
                    ? FontWeight.bold
                    : FontWeight.normal,
                  color: seleccionado
                    ? Colors.white
                    : Theme.of(context).primaryColor
                ),
              ),
              Text(
                medico.titulo,
                style: TextStyle(
                  fontWeight: seleccionado
                    ? FontWeight.bold
                    : FontWeight.normal,
                  color: seleccionado
                    ? Colors.white
                    : Theme.of(context).primaryColor
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkboxPersonalizadoDia(context, {
    required Dia dia, 
    required bool seleccionado,
    required VoidCallback onPressed 
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 750),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6
        ),
        decoration: BoxDecoration(
          color: seleccionado
            ? Theme.of(context).primaryColor
            : Colors.white,
          border: Border.all(
            color: Theme.of(context).primaryColor
          )
        ),
        child: Text(
          dia.nombre.substring(0, 3),
          style: TextStyle(
            fontWeight: seleccionado
              ? FontWeight.bold
              : FontWeight.normal,
            color: seleccionado
              ? Colors.white
              : Theme.of(context).primaryColor
          ),
        ),
      ),
    );
  } 
}
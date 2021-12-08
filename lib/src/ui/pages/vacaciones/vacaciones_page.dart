import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/bloc/vacaciones/crear_vacacion_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/vacaciones/editar_vacacion_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/vacaciones/vacaciones_bloc.dart';
import 'package:harry_williams_app/src/core/models/medico.dart';
import 'package:harry_williams_app/src/core/models/vacacion.dart';
import 'package:harry_williams_app/src/utils/dialogs_carga.dart';
import 'package:harry_williams_app/src/utils/toast.dart';
import 'package:intl/intl.dart';

class VacacionesPage extends StatelessWidget {
  VacacionesPage({ Key? key }) : super(key: key);

  final _vacacionesBloc = VacacionesBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vacaciones')
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => _mostrarDialogCrearVacacion(context),
        child: Text('Crear Vacacion')
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Vacacion>>(
              stream: _vacacionesBloc.vacacionesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text(snapshot.error.toString());

                if (snapshot.hasData) {
                  final vacaciones = snapshot.data!;
                  if (vacaciones.isEmpty) {
                    return const Center(
                      child: Text('No existen vacaciones registradas')
                    );
                  }

                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: vacaciones.length,
                    itemBuilder: (context, index) {
                      final vacacion = vacaciones[index];
                      final horaInicio = vacacion.fechaInicio;
                      final horaFin = vacacion.fechaFin;
                      final horaInicioLiteral = DateFormat('dd/MM/yyyy').format(horaInicio);
                      final horaFinLiteral = DateFormat('dd/MM/yyyy').format(horaFin);
                      return ListTile(
                        title: Text(
                          'Médico: ' + vacacion.medico.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        subtitle: Text(
                          'Desde: $horaInicioLiteral - Hasta: $horaFinLiteral'
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) {
                            return <PopupMenuEntry>[
                              const PopupMenuItem(
                                child: Text(
                                  'Editar',
                                ),
                                value: 1,
                              ),
                              const PopupMenuItem(
                                child: Text(
                                  'Eliminar'
                                ),
                                value: 2,
                              )
                            ];
                          },
                          onSelected: (value) {
                            switch (value) {
                              case 1:
                                _mostrarDialogEditarVacacion(context, vacacion);
                                break;
                              case 2:
                                _mostrarDialogEliminarVacacion(context, vacacion);
                                break;
                              default:
                                break;
                            }
                          },
                        ),
                      );
                    },
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ),
        ],
      )
    );
  }

  void _mostrarDialogEliminarVacacion(BuildContext context, Vacacion vacacion) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            '¿Estás seguro de eliminar la vacacion?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar')
            ),
            TextButton(
              onPressed: () async {
                try {
                  DialogsCarga.mostrarCircular(context);
                  await _vacacionesBloc.eliminar(vacacion);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Toast.mostrarCorrecto(
                    mensaje: 'Se elimino la vacación correctamente'
                  );
                } catch (e) {
                  Navigator.pop(context);
                  print(e);
                  Toast.mostrarIncorrecto(
                    mensaje: 'La vacación no se pudo eliminar'
                  );
                }
              },
              child: Text('Aceptar')
            )
          ],
        );
      }
    );
  }

  void _mostrarDialogCrearVacacion(BuildContext context) {
    final _crearVacacionBloc = CrearVacacionBloc();
    _crearVacacionBloc.obtenerMedicos();

    void _crearVacacion() async {
      try {
        DialogsCarga.mostrarCircular(context);
        _crearVacacionBloc.crear();
        Navigator.pop(context);
        Navigator.pop(context);
        Toast.mostrarCorrecto(mensaje: 'Vacación creada correctamente');
      } catch (error) {
        print(error);
        Navigator.pop(context);
        Toast.mostrarIncorrecto(mensaje: 'La vacación no se pudo crear');
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Crear Vacación',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    )
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<List<Medico>>(
                    stream: _crearVacacionBloc.medicosStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final medicos = snapshot.data!;
                        return StreamBuilder<Medico>(
                          stream: _crearVacacionBloc.medicoStream,
                          builder: (context, seleccionadaSnapshot) {
                            final medicoSeleccionado = seleccionadaSnapshot.data;
                            return DropdownButton<Medico>(
                              items: medicos.map((item) {
                                return DropdownMenuItem<Medico>(
                                  child: Text(item.nombre),
                                  value: item,
                                );
                              }).toList(),
                              value: medicoSeleccionado,
                              onChanged: (valor) {
                                if (valor != null) {
                                  _crearVacacionBloc.medico = valor;
                                }
                              },
                            );
                          },
                        );
                      }
                      return Text('Cargando Medicos...');
                    },
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<DateTime>(
                    stream: _crearVacacionBloc.fechaInicioStream,
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
                            _crearVacacionBloc.fechaInicio = _nuevaFechaInicio;
                          }
                        },
                      );
                    }
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<DateTime>(
                    stream: _crearVacacionBloc.fechaFinStream,
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
                            _crearVacacionBloc.fechaFin = _nuevaFechaFin;
                          }
                        },
                      );
                    }
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerRight,
                    child: StreamBuilder(
                      stream: _crearVacacionBloc.formularioLlenadoCorrectamenteStream,
                      builder: (context, snapshot) {
                        final botonActivo = (snapshot.hasData && snapshot.data == true);
                        return ElevatedButton(
                          child: const Text('Crear'),
                          onPressed: botonActivo
                            ? _crearVacacion
                            : null
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
          )
        );
      }
    );
  }

  void _mostrarDialogEditarVacacion(BuildContext context, Vacacion vacacion) {
    final _editarVacacionBloc = EditarVacacionBloc(vacacion);
    _editarVacacionBloc.obtenerMedicos();

    void _editarVacacion() async {
      try {
        DialogsCarga.mostrarCircular(context);
        _editarVacacionBloc.editar();
        Navigator.pop(context);
        Navigator.pop(context);
        Toast.mostrarCorrecto(mensaje: 'Vacacion editada correctamente');
      } catch (error) {
        print(error);
        Navigator.pop(context);
        Toast.mostrarIncorrecto(mensaje: 'La vacacion no se pudo editar');
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Editar Vacación',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    )
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<DateTime>(
                    stream: _editarVacacionBloc.fechaInicioStream,
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
                            initialDate: fechaInicio!,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365))
                          );
                          if (_nuevaFechaInicio != null) {
                            _editarVacacionBloc.fechaInicio = _nuevaFechaInicio;
                          }
                        },
                      );
                    }
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<DateTime>(
                    stream: _editarVacacionBloc.fechaFinStream,
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
                            initialDate: fechaFin!,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365))
                          );
                          if (_nuevaFechaFin != null) {
                            _editarVacacionBloc.fechaFin = _nuevaFechaFin;
                          }
                        },
                      );
                    }
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerRight,
                    child: StreamBuilder(
                      stream: _editarVacacionBloc.formularioLlenadoCorrectamenteStream,
                      builder: (context, snapshot) {
                        final botonActivo = (snapshot.hasData && snapshot.data == true);
                        return ElevatedButton(
                          child: const Text('Editar'),
                          onPressed: botonActivo
                            ? _editarVacacion
                            : null
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
          )
        );
      }
    );
  }
}
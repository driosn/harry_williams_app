import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/bloc/dias_festivos/crear_dia_festivo_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/dias_festivos/dias_festivos_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/vacaciones/crear_vacacion_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/vacaciones/editar_vacacion_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/vacaciones/vacaciones_bloc.dart';
import 'package:harry_williams_app/src/core/models/dia_festivo.dart';
import 'package:harry_williams_app/src/core/models/medico.dart';
import 'package:harry_williams_app/src/core/models/vacacion.dart';
import 'package:harry_williams_app/src/utils/dialogs_carga.dart';
import 'package:harry_williams_app/src/utils/toast.dart';
import 'package:intl/intl.dart';

class DiasFestivosPage extends StatelessWidget {
  DiasFestivosPage({ Key? key }) : super(key: key);

  final _diasFestivosBloc = DiasFestivosBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dias Festivos')
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => _mostrarDialogCrearDiaFestivo(context),
        child: Text('Crear Dia Festivo')
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
            child: StreamBuilder<List<DiaFestivo>>(
              stream: _diasFestivosBloc.diasFestivosStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text(snapshot.error.toString());

                if (snapshot.hasData) {
                  final diasFestivos = snapshot.data!;
                  if (diasFestivos.isEmpty) {
                    return const Center(
                      child: Text('No existen dias festivos registrados')
                    );
                  }

                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: diasFestivos.length,
                    itemBuilder: (context, index) {
                      final dia = diasFestivos[index];
                      final nombre = dia.nombre;
                      final fecha = dia.fecha;
                      final fechaLiteral = DateFormat('dd/MM/yyyy').format(fecha);
                      return ListTile(
                        title: Text(
                          nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        subtitle: Text(
                          'Fecha: $fechaLiteral'
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) {
                            return <PopupMenuEntry>[
                              const PopupMenuItem(
                                child: Text(
                                  'Eliminar'
                                ),
                                value: 1,
                              )
                            ];
                          },
                          onSelected: (value) {
                            switch (value) {
                              case 1:
                                _mostrarDialogEliminarDiaFestivo(context, dia);
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

  void _mostrarDialogEliminarDiaFestivo(BuildContext context, DiaFestivo diaFestivo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            '¿Estás seguro de eliminar el día festivo?',
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
                  await _diasFestivosBloc.eliminar(diaFestivo);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Toast.mostrarCorrecto(
                    mensaje: 'Se elimino el día festivo correctamente'
                  );
                } catch (e) {
                  Navigator.pop(context);
                  print(e);
                  Toast.mostrarIncorrecto(
                    mensaje: 'El día festivo no se pudo eliminar'
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

  void _mostrarDialogCrearDiaFestivo(BuildContext context) {
    final _crearDiaFestivoBloc = CrearDiaFestivoBloc();

    void _crearDiaFestivo() async {
      try {
        DialogsCarga.mostrarCircular(context);
        _crearDiaFestivoBloc.crear();
        Navigator.pop(context);
        Navigator.pop(context);
        Toast.mostrarCorrecto(mensaje: 'Dia festivo creado correctamente');
      } catch (error) {
        print(error);
        Navigator.pop(context);
        Toast.mostrarIncorrecto(mensaje: 'Eldia festivo no se pudo crear');
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
                    'Crear Dío Festivo',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    )
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Nombre de día festivo',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (valor) {
                      _crearDiaFestivoBloc.nombre = valor;
                    },
                  ),
                  const SizedBox(height: 12),
                  StreamBuilder<DateTime>(
                    stream: _crearDiaFestivoBloc.fechaStream,
                    builder: (context, snapshot) {
                      final fecha = snapshot.data;
                      String fechaLiteral = "No seleccionado";
                      if (fecha != null) {
                        fechaLiteral = DateFormat('dd/MM/yyyy').format(fecha);
                      }
                      return ListTile(
                        title: Text('Fecha'),
                        trailing: Text(fechaLiteral),
                        onTap: () async {
                          final _nuevaFecha = await showDatePicker(
                            context: context, 
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365))
                          );
                          if (_nuevaFecha != null) {
                            _crearDiaFestivoBloc.fecha = _nuevaFecha;
                          }
                        },
                      );
                    }
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerRight,
                    child: StreamBuilder(
                      stream: _crearDiaFestivoBloc.formularioLlenadoCorrectamenteStream,
                      builder: (context, snapshot) {
                        final botonActivo = (snapshot.hasData && snapshot.data == true);
                        return ElevatedButton(
                          child: const Text('Crear'),
                          onPressed: botonActivo
                            ? _crearDiaFestivo
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
                          child: const Text('Crear'),
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
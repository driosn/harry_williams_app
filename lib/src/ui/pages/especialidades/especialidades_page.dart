import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/bloc/especialidades/crear_especialidad_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/especialidades/editar_especialidad_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/especialidades/especialidades_bloc.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/utils/dialogs_carga.dart';
import 'package:harry_williams_app/src/utils/toast.dart';

class EspecialidadesPage extends StatelessWidget {
  EspecialidadesPage({ Key? key }) : super(key: key);

  final _especialidadesBloc = EspecialidadesBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Especialidades')
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => _mostrarDialogCrearEspecialidad(context),
        child: Text('Crear Especialidad')
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8
            ),
            child: _buscadorEspecialidades(),
          ),
          Expanded(
            child: StreamBuilder<List<Especialidad>>(
              stream: _especialidadesBloc.especialidadesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text(snapshot.error.toString());

                if (snapshot.hasData) {
                  final especialidades = snapshot.data!;
                  if (especialidades.isEmpty) {
                    return const Center(
                      child: Text('No existen especialidades registradas')
                    );
                  }

                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: especialidades.length,
                    itemBuilder: (context, index) {
                      final especialidad = especialidades[index];
                      return ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            _especialidadesBloc.actualizarEstadoVigente(especialidad); 
                          },
                          child: AnimatedContainer(
                            duration: const Duration(
                              milliseconds: 750
                            ),
                            width: 40,
                            color: especialidad.estadoVigente
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                        title: Text(
                          especialidad.clasificacion,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        subtitle: Text(
                          especialidad.codigo, 
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
                                _mostrarDialogEditarEspecialidad(context, especialidad);
                                break;
                              case 2:
                                _mostrarDialogEliminarEspecialidad(context, especialidad);
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

  void _eliminarEspecialidad(BuildContext context, Especialidad especialidad) async {
    try {
      DialogsCarga.mostrarCircular(context);
      await _especialidadesBloc.eliminar(especialidad);
      Navigator.pop(context);
      Toast.mostrarCorrecto(mensaje: 'Especialidad eliminada correctamente');
    } catch (e) {
      print(e);
      Navigator.pop(context);
      Toast.mostrarIncorrecto(mensaje: 'La especialidad no se pudo eliminar');
    }
  }

  void _mostrarDialogEliminarEspecialidad(BuildContext context, Especialidad especialidad) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            '¿Estás seguro de eliminar la especialidad?',
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
                  await _especialidadesBloc.eliminar(especialidad);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Toast.mostrarCorrecto(
                    mensaje: 'Se elimino la especialidad correctamente'
                  );
                } catch (e) {
                  Navigator.pop(context);
                  print(e);
                  Toast.mostrarIncorrecto(
                    mensaje: 'La especialidad no se pudo eliminar'
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

  void _mostrarDialogCrearEspecialidad(BuildContext context) {
    final _crearEspecialidadBloc = CrearEspecialidadBloc();
    
    void _crearEspecialidad() async {
      try {
        DialogsCarga.mostrarCircular(context);
        _crearEspecialidadBloc.crear();
        Navigator.pop(context);
        Navigator.pop(context);
        Toast.mostrarCorrecto(mensaje: 'Especialidad creada correctamente');
      } catch (error) {
        print(error);
        Navigator.pop(context);
        Toast.mostrarIncorrecto(mensaje: 'La especialidad no se pudo crear');
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
                    'Crear Especialidad',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    )
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Codigo'
                    ),
                    onChanged: (nuevoCodigo) => _crearEspecialidadBloc.codigo = nuevoCodigo
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Clasificacion'
                    ),
                    onChanged: (nuevaClasificacion) => _crearEspecialidadBloc.clasificacion = nuevaClasificacion
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerRight,
                    child: StreamBuilder(
                      stream: _crearEspecialidadBloc.formularioLlenadoCorrectamenteStream,
                      builder: (context, snapshot) {
                        final botonActivo = (snapshot.hasData && snapshot.data == true);
                        return ElevatedButton(
                          child: const Text('Crear'),
                          onPressed: botonActivo
                            ? _crearEspecialidad
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

  void _mostrarDialogEditarEspecialidad(BuildContext context, Especialidad especialidad) {
    final _editarEspecialidadBloc = EditarEspecialidadBloc(especialidad);
    final _codigoController = TextEditingController()..text = especialidad.codigo;
    final _clasificacionController = TextEditingController()..text = especialidad.clasificacion;

    void _editarEspecialidad() async {
      try {
        DialogsCarga.mostrarCircular(context);
        _editarEspecialidadBloc.editar();
        Navigator.pop(context);
        Navigator.pop(context);
        Toast.mostrarCorrecto(mensaje: 'Especialidad editada correctamente');
      } catch (error) {
        print(error);
        Navigator.pop(context);
        Toast.mostrarIncorrecto(mensaje: 'La especialidad no se pudo editar');
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
                    'Editar Especialidad',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    )
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _codigoController,
                    decoration: const InputDecoration(
                      hintText: 'Codigo'
                    ),
                    onChanged: (nuevoCodigo) => _editarEspecialidadBloc.codigo = nuevoCodigo
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _clasificacionController,
                    decoration: const InputDecoration(
                      hintText: 'Clasificacion'
                    ),
                    onChanged: (nuevaClasificacion) => _editarEspecialidadBloc.clasificacion = nuevaClasificacion
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerRight,
                    child: StreamBuilder(
                      stream: _editarEspecialidadBloc.formularioLlenadoCorrectamenteStream,
                      builder: (context, snapshot) {
                        final botonActivo = (snapshot.hasData && snapshot.data == true);
                        return ElevatedButton(
                          child: const Text('Crear'),
                          onPressed: botonActivo
                            ? _editarEspecialidad
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

  Widget _buscadorEspecialidades() {
    return TextField(
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.search),
        hintText: 'Buscar especialidad'
      ),
    );
  }
}
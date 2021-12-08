import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/bloc/especialidades/crear_especialidad_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/especialidades/especialidades_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/medicos/crear_medico_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/medicos/editar_medico_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/medicos/medicos_bloc.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/core/models/medico.dart';
import 'package:harry_williams_app/src/ui/dialogs/dialogs_cargando.dart';
import 'package:harry_williams_app/src/utils/dialogs_carga.dart';
import 'package:harry_williams_app/src/utils/toast.dart';

class MedicosPage extends StatelessWidget {
  MedicosPage({ Key? key }) : super(key: key);

  final _medicosBloc = MedicosBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicos')
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => _mostrarDialogCrearMedico(context),
        child: Text('Crear Médico')
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8
            ),
            child: _buscadorMedicos(),
          ),
          Expanded(
            child: StreamBuilder<List<Medico>>(
              stream: _medicosBloc.medicosStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text(snapshot.error.toString());

                if (snapshot.hasData) {
                  final medicos = snapshot.data!;
                  if (medicos.isEmpty) {
                    return const Center(
                      child: Text('No existen medicos registrados')
                    );
                  }

                  return ListView.builder(
                    itemCount: medicos.length,
                    itemBuilder: (context, index) {
                      final medico = medicos[index];
                      return ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            _medicosBloc.actualizarEstadoVigente(medico);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 750),
                            width: 40,
                            decoration: BoxDecoration(
                              color: medico.estadoVigente
                                ? Colors.green
                                : Colors.red
                            ),
                          ),
                        ),
                        title: Text(
                          medico.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        subtitle: Text(
                          medico.titulo
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) {
                            return <PopupMenuEntry>[
                              const PopupMenuItem(
                                value: 1,
                                child: Text('Editar'),
                              ),
                              const PopupMenuItem(
                                value: 2,
                                child: Text('Eliminar')
                              )
                            ];
                          },
                          onSelected: (valor) {
                            switch (valor) {
                              case 1:
                                  _mostrarDialogEditarMedico(context, medico);
                                break;
                              case 2:
                                  _mostrarDialogEliminarMedico(context, medico);
                                break;
                            }
                          }
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

  void _mostrarDialogEditarMedico(BuildContext context, Medico medico) {
    final _editarMedicoBloc = EditarMedicoBloc(medico);
    final _nombreController = TextEditingController()..text = medico.nombre;
    final _numeroMatriculaController = TextEditingController()..text = medico.numeroMatricula;
    final _tituloController = TextEditingController()..text = medico.titulo;
    
    void _editarMedico(BuildContext context) async {
      try {
        DialogsCarga.mostrarCircular(context);
        await _editarMedicoBloc.editar();
        Navigator.pop(context);
        Navigator.pop(context);
        Toast.mostrarCorrecto(mensaje: 'Médico editado correctamente');
      } catch (e) {
        Navigator.pop(context);
        Toast.mostrarIncorrecto(mensaje: 'El médico no se pudo editar');
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
                    'Crear Medico',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    )
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      hintText: 'Nombre'
                    ),
                    onChanged: (valor) => _editarMedicoBloc.nombre = valor
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _numeroMatriculaController,
                    decoration: const InputDecoration(
                      hintText: 'Numero Matricula'
                    ),
                    onChanged: (valor) => _editarMedicoBloc.numeroMatricula = valor
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _tituloController,
                    decoration: const InputDecoration(
                      hintText: 'Titulo'
                    ),
                    onChanged: (valor) => _editarMedicoBloc.titulo = valor
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: StreamBuilder(
                      stream: _editarMedicoBloc.formularioLlenadoCorrectamenteStream,
                      builder: (context, snapshot) {
                        final botonActivo = (snapshot.hasData && snapshot.data == true);
                        return ElevatedButton(
                          child: const Text('Editar'),
                          onPressed: botonActivo
                            ? () {
                              _editarMedico(context);
                            }
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

  void _mostrarDialogEliminarMedico(BuildContext context, Medico medico) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            '¿Está seguro de elimnar el médico?'
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () async {
                try {
                  DialogsCarga.mostrarCircular(context);
                  await _medicosBloc.eliminar(medico);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Toast.mostrarCorrecto(mensaje: 'El medico se elimino correctamente');
                } catch (e) {
                  Navigator.pop(context);
                  Toast.mostrarIncorrecto(mensaje: 'El medico no se pudo eliminar');
                }
              },
            )
          ],
        );
      }
    );
  }

  void _mostrarDialogCrearMedico(BuildContext context) {
    final _crearMedicoBloc = CrearMedicoBloc();
    
    void _crearMedico() async {
      try {
        DialogsCarga.mostrarCircular(context);
        await _crearMedicoBloc.crear();
        Navigator.pop(context);
        Navigator.pop(context);
        Toast.mostrarCorrecto(mensaje: 'Médico creado correctamente');
      } catch (e) {
        Navigator.pop(context);
        print(e.toString());
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
                    'Crear Medico',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    )
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Nombre'
                    ),
                    onChanged: (valor) => _crearMedicoBloc.nombre = valor
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Numero Matricula'
                    ),
                    onChanged: (valor) => _crearMedicoBloc.numeroMatricula = valor
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Titulo'
                    ),
                    onChanged: (valor) => _crearMedicoBloc.titulo = valor
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: StreamBuilder(
                      stream: _crearMedicoBloc.formularioLlenadoCorrectamenteStream,
                      builder: (context, snapshot) {
                        final botonActivo = (snapshot.hasData && snapshot.data == true);
                        return ElevatedButton(
                          child: Text('Crear'),
                          onPressed: botonActivo
                            ? _crearMedico
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

  Widget _buscadorMedicos() {
    return TextField(
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.search),
        hintText: 'Buscar médico'
      ),
    );
  }
}
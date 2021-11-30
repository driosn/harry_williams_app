import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/bloc/crear_especialidad_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/especialidades_bloc.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/ui/dialogs/dialogs_cargando.dart';

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
                        title: Text(especialidad.clasificacion),
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

  void _mostrarDialogCrearEspecialidad(BuildContext context) {
    final _crearEspecialidadBloc = CrearEspecialidadBloc();
    
    void _crearEspecialidad() async {
      try {
        await DialogsCargando.mostrarSalud(context);
        await Future.delayed(Duration(seconds: 3));
        _crearEspecialidadBloc.crear();
        Navigator.pop(context);
        Navigator.pop(context);
      } catch (error) {
        print(error);
        Navigator.pop(context);
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
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
                  decoration: InputDecoration(
                    hintText: 'Codigo'
                  ),
                  onChanged: (nuevoCodigo) => _crearEspecialidadBloc.codigo = nuevoCodigo
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Clasificacion'
                  ),
                  onChanged: (nuevaClasificacion) => _crearEspecialidadBloc.clasificacion = nuevaClasificacion
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final _nuevaHoraInicio = await showTimePicker(
                          context: context, 
                          initialTime: TimeOfDay.now()
                        );
                        if (_nuevaHoraInicio != null) _crearEspecialidadBloc.horaInicio = _nuevaHoraInicio;
                      },
                      child: Text('Hora Inicio')
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final _nuevaHoraFin = await showTimePicker(
                          context: context, 
                          initialTime: TimeOfDay.now()
                        );
                        if (_nuevaHoraFin != null) _crearEspecialidadBloc.horaFinal = _nuevaHoraFin;
                      },
                      child: Text('Hora Fin')
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Minutos Atencion'
                  ),
                  onChanged: (nuevosMinutos) {
                    _crearEspecialidadBloc.minutosAtencion = int.tryParse(nuevosMinutos) ?? 0;
                  }
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerRight,
                  child: StreamBuilder(
                    stream: _crearEspecialidadBloc.formularioLlenadoCorrectamenteStream,
                    builder: (context, snapshot) {
                      final botonActivo = (snapshot.hasData && snapshot.data == true);
                      return ElevatedButton(
                        child: Text('Crear'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            botonActivo ? Colors.blue : Colors.grey
                          )
                        ),
                        onPressed: botonActivo
                          ? _crearEspecialidad
                          : null
                      );
                    }
                  ),
                )
              ],
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
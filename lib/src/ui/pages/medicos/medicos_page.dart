import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/bloc/crear_especialidad_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/especialidades_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/medicos/crear_medico_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/medicos/medicos_bloc.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';
import 'package:harry_williams_app/src/core/models/medico.dart';

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
          _buscadorMedicos(),
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
                        title: Text(medico.nombre),
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

  void _mostrarDialogCrearMedico(BuildContext context) {
    final _crearMedicoBloc = CrearMedicoBloc();
    
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
                          ? _crearMedicoBloc.crear
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

  Widget _buscadorMedicos() {
    return TextField(
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.search)
      )
    );
  }
}
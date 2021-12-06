import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/models/cita.dart';
import 'package:harry_williams_app/src/core/models/programacion.dart';
import 'package:harry_williams_app/src/core/models/usuario.dart';
import 'package:intl/intl.dart';

class CitasService {
  static final  _firestore = FirebaseFirestore.instance;
  
  static const String _nombreColeccion = 'citas';
  final CollectionReference citas = _firestore.collection(_nombreColeccion);

  Future<void> crear(Cita cita) async {
    await citas.add(cita.toMap());
  }

  Future<void> crearEnBaseAProgramacion(Programacion programacion) async {
      const valorDefecto = 'No asignado';
      
      final fechaActual = DateTime.now();
      DateTime fechaInicio = programacion.fechaInicio;
      DateTime fechaFin = programacion.fechaFin;
      TimeOfDay horaInicio = programacion.horaInicio;
      TimeOfDay horaFin = programacion.horaFin;
      List<String> diasDeAtencionEnIngles = programacion.dias.map((dia) => dia.nombreIngles).toList();
      
      int numeroFichas = programacion.numeroFichas;

      Usuario defectoNoAsignado = Usuario(
        id: '-1',
        nombre: valorDefecto,
        apellido: valorDefecto,
        contrasena: valorDefecto, 
        estadoVigente: false, 
        nombreUsuario: valorDefecto,
        email: valorDefecto,
        rol: valorDefecto
      );

      DateTime horaInicioAuxiliar = DateTime(
        fechaActual.year, 
        fechaActual.month, 
        fechaActual.day, 
        horaInicio.hour, 
        horaFin.minute
      );
      DateTime horaFinAuxiliar = DateTime(
        fechaActual.year, 
        fechaActual.month, 
        fechaActual.day, 
        horaFin.hour, 
        horaFin.minute
      );

      int minutosTotalesDeAtencion = horaInicioAuxiliar.difference(horaFinAuxiliar).inMinutes.abs();
      int minutosPorFicha = minutosTotalesDeAtencion ~/ numeroFichas;

      for(DateTime fechaIterador = fechaInicio; (fechaIterador.isBefore(fechaFin) || fechaIterador.isAtSameMomentAs(fechaFin)); fechaIterador = fechaIterador.add(const Duration(days: 1))) {
          final nombreDelDiaEnIngles = DateFormat('EEEE').format(fechaIterador);
          if(diasDeAtencionEnIngles.contains(nombreDelDiaEnIngles)) {
            for(int i = 0; i < numeroFichas; i++) {
              final cantidadIteraciones = i;
              DateTime nuevaHoraInicio = horaInicioAuxiliar.add(Duration(minutes: (cantidadIteraciones * minutosPorFicha)));
              DateTime nuevaHoraFin;
              if (i == (numeroFichas - 1)) {
                nuevaHoraFin = horaFinAuxiliar;
              } else {
                nuevaHoraFin = nuevaHoraInicio.add(Duration(minutes: minutosPorFicha));
              }
    
              final nuevaCita = Cita(
                especialidad: programacion.especialidad,
                medico: programacion.medico,
                fecha: fechaIterador,
                horaInicio: TimeOfDay(
                  hour: nuevaHoraInicio.hour,
                  minute: nuevaHoraInicio.minute
                ),
                horaFin: TimeOfDay(
                  hour: nuevaHoraFin.hour,
                  minute: nuevaHoraFin.minute
                ),
                paciente: defectoNoAsignado,
              );
    
              await crear(nuevaCita);
            }
          }
      }
  }

  Future<List<Cita>> listar() async {
    final querySnapshots = await citas.get();
    final documents = querySnapshots.docs;
    final citasMapeadas = documents.map((item) => Cita.desdeDocumentSnapshot(item)).toList();
    return citasMapeadas;
  }

  Future<List<Cita>> listarPorEspecialidadMedicoDia(String especialidadId, String medicoId, DateTime dia) async {
    final querySnapshots = await citas
      .where('especialidad.id', isEqualTo: especialidadId)
      .where('medico.id', isEqualTo: medicoId)
      .where('fecha', isEqualTo: Timestamp.fromDate(dia))
      .get();
    final documents = querySnapshots.docs;
    final citasMapeadas = documents.map((item) => Cita.desdeDocumentSnapshot(item)).toList();
    return citasMapeadas;
  }

  Future<void> agendarCitaAPaciente(Cita cita, Usuario paciente) async {
    await cita.reference!.update({'paciente': paciente.toMap()});
  }
}
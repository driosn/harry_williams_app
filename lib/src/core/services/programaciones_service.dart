import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/models/programacion.dart';

class ProgramacionesService {
  static final  _firestore = FirebaseFirestore.instance;
  
  static const String _nombreColeccion = 'programaciones';
  final CollectionReference programaciones = _firestore.collection(_nombreColeccion);

  Future<void> crear(Programacion nuevaProgramacion) async {
    await programaciones.add(nuevaProgramacion.toMap());
  }

  Future<List<Programacion>> listar() async {
    final querySnapshots = await programaciones.get();
    final documents = querySnapshots.docs;
    final programacionesMapeadas = documents.map((item) => Programacion.desdeDocumentSnapshot(item)).toList();
    return programacionesMapeadas;
  }

  Future<List<Programacion>> listarPorEspecialidadId(String especialidadId) async {
    final querySnapshots = await programaciones.where('especialidad.id', isEqualTo: especialidadId).get();
    final documents = querySnapshots.docs;
    final programacionesMapeadas = documents.map((item) => Programacion.desdeDocumentSnapshot(item)).toList();
    return programacionesMapeadas;
  }

  Future<void> eliminar(Programacion programacion) async {
    await programacion.reference!.delete();
  }
}
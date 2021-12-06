import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';

class EspecialidadService {
  static final  _firestore = FirebaseFirestore.instance;
  
  static const String _nombreColeccion = 'especialidades';
  final CollectionReference especialidades = _firestore.collection(_nombreColeccion);

  Future<void> crear(Especialidad nuevaEspecialidad) async {
    await especialidades.add(nuevaEspecialidad.toMap());
  }

  Future<List<Especialidad>> listar() async {
    final querySnapshots = await especialidades.get();
    final documents = querySnapshots.docs;
    final especialidadesMapeadas = documents.map((item) => Especialidad.desdeDocumentSnapshot(item)).toList();
    return especialidadesMapeadas;
  }

  Future<void> actualizarEstadoVigente(Especialidad esp) async {
    await esp.reference!.update({'estadoVigente': !esp.estadoVigente});
  }

  Future<void> actualizar(Especialidad esp) async {
    await esp.reference!.set(esp.toMap());
  }

  Future<void> eliminar(Especialidad esp) async {
    await esp.reference!.delete();
  }
}
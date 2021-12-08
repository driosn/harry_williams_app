import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/models/vacacion.dart';

class VacacionesService {
  static final  _firestore = FirebaseFirestore.instance;
  
  static const String _nombreColeccion = 'vacaciones';
  final CollectionReference vacaciones = _firestore.collection(_nombreColeccion);

  Future<void> crear(Vacacion nuevaVacacion) async {
    await vacaciones.add(nuevaVacacion.toMap());
  }

  Future<List<Vacacion>> listar() async {
    final querySnapshots = await vacaciones.get();
    final documents = querySnapshots.docs;
    final vacacionesMapeadas = documents.map((item) => Vacacion.desdeDocumentSnapshot(item)).toList();
    return vacacionesMapeadas;
  }

  Future<List<Vacacion>> listarPorMedicoId(String id) async {
    final querySnapshots = await vacaciones.where('medico.id', isEqualTo: id).get();
    final documents = querySnapshots.docs;
    final vacacionesMapeadas = documents.map((item) => Vacacion.desdeDocumentSnapshot(item)).toList();
    return vacacionesMapeadas;
  }

  Future<void> editar(Vacacion vacacion) async {
    await vacacion.reference!.set(vacacion.toMap());
  }

  Future<void> eliminar(Vacacion vacacion) async {
    await vacacion.reference!.delete();
  }
}
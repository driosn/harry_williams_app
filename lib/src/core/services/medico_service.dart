import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/models/medico.dart';

class MedicosService {
  static const String _nombreColeccion = 'medicos';
  final CollectionReference medicos = FirebaseFirestore.instance.collection(_nombreColeccion);

  Future<void> crear(Medico nuevoMedico) async {
    await medicos.add(nuevoMedico.toMap());
  }

  Future<List<Medico>> listar() async {
    final querySnapshots = await medicos.get();
    final documents = querySnapshots.docs;
    final medicosMapeados = documents.map((item) => Medico.desdeDocumentSnapshot(item)).toList();
    return medicosMapeados;
  }
}
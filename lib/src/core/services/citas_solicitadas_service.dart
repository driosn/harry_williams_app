import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/models/cita_solicitada.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';

class CitasSolicitadasService {
  static final  _firestore = FirebaseFirestore.instance;
  
  static const String _nombreColeccion = 'citasSolicitadas';
  final CollectionReference citasSolicitadas = _firestore.collection(_nombreColeccion);

  Future<void> crear(CitaSolicitada nuevaCitaSolicitada) async {
    await citasSolicitadas.add(nuevaCitaSolicitada.toMap());
  }

  Future<List<CitaSolicitada>> listar() async {
    final querySnapshots = await citasSolicitadas.get();
    final documents = querySnapshots.docs;
    final citasMapeadas = documents.map((item) => CitaSolicitada.desdeDocumentSnapshot(item)).toList();
    return citasMapeadas;
  }

  Future<void> cambiarEstadoAdmin(CitaSolicitada citaSolicitada, String estado) async {
    await citaSolicitada.reference!.update({'estadoCita': estado});
  }

  Future<void> cancelar(CitaSolicitada citaSolicitada) async {
    await citaSolicitada.reference!.update({'estadoCita': 'cancelada'});
  }

  Future<void> eliminar(Especialidad esp) async {
    await esp.reference!.delete();
  }
}
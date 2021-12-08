import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/models/dia_festivo.dart';
import 'package:harry_williams_app/src/core/models/vacacion.dart';

class DiasFestivosService {
  static final  _firestore = FirebaseFirestore.instance;
  
  static const String _nombreColeccion = 'diasFestivos';
  final CollectionReference diasFestivos = _firestore.collection(_nombreColeccion);

  Future<void> crear(DiaFestivo diaFestivo) async {
    await diasFestivos.add(diaFestivo.toMap());
  }

  Future<List<DiaFestivo>> listar() async {
    final querySnapshots = await diasFestivos.get();
    final documents = querySnapshots.docs;
    final diasMapeados = documents.map((item) => DiaFestivo.desdeDocumentSnapshot(item)).toList();
    return diasMapeados;
  }

  Future<void> eliminar(DiaFestivo diaFestivo) async {
    await diaFestivo.reference!.delete();
  }
}
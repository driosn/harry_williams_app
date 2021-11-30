import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/models/especialidad.dart';

class EspecialidadService {
  static final  _firestore = FirebaseFirestore.instance;
  
  static const String _nombreColeccion = 'especialidades';
  final CollectionReference especialidades = _firestore.collection(_nombreColeccion);

  Future<void> crear(Especialidad nuevaEspecialidad) async {
    await especialidades.add(nuevaEspecialidad.toMap());
  }
}
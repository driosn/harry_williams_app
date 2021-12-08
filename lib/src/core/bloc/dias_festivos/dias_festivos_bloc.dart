import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/models/dia_festivo.dart';
import 'package:harry_williams_app/src/core/services/dias_festivos_service.dart';

class DiasFestivosBloc {

  static const _nombreColeccion = 'diasFestivos';
  final _diasFestivosService = DiasFestivosService();
  
  static final CollectionReference diasFestivos = FirebaseFirestore.instance.collection(_nombreColeccion);

  Stream<List<DiaFestivo>> get diasFestivosStream => diasFestivos.snapshots().map<List<DiaFestivo>>((event) {
      return event.docs.map((item) {
        return DiaFestivo.desdeDocumentSnapshot(item);
      }).toList();
  });

  Future<void> eliminar(DiaFestivo diaFestivo) async => await _diasFestivosService.eliminar(diaFestivo);
}
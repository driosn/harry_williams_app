import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harry_williams_app/src/core/bloc/usuarios/usuario_bloc.dart';
import 'package:harry_williams_app/src/core/models/cita_solicitada.dart';

class CitasSolicitadasBloc {

  static const _nombreColeccion = 'citasSolicitadas';

  static final CollectionReference citasSolicitadas = FirebaseFirestore.instance.collection(_nombreColeccion);

  Stream<List<CitaSolicitada>> get todasLasCitasSolicitadasStream => citasSolicitadas.snapshots().map<List<CitaSolicitada>>((event) {
                  return event.docs.map((item) {
                    return CitaSolicitada.desdeDocumentSnapshot(item);
                  }).toList();
              });

  Stream<List<CitaSolicitada>> get misCitasSolicitadasStream => citasSolicitadas
              .where('cita.paciente.id', isEqualTo: usuarioBloc.usuario.id!).snapshots().map<List<CitaSolicitada>>((event) {
                  return event.docs.map((item) {
                    return CitaSolicitada.desdeDocumentSnapshot(item);
                  }).toList();
              });
}
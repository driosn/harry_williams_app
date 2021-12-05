import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:harry_williams_app/src/core/models/usuario.dart';

class UsuariosService {

  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final  _firestore = FirebaseFirestore.instance;
  
  static const String _nombreColeccion = 'usuarios';
  final CollectionReference usuarios = _firestore.collection(_nombreColeccion);

  final rolPaciente = 'PAC';
  final rolAdmin = 'ADM';

  Future<void> crear(Usuario nuevoUsuario) async {
    await usuarios.doc(nuevoUsuario.id).set(nuevoUsuario.toMap());
  }

  Future<Usuario> obtenerPorId(String id) async {
    final documentSnapshot = await usuarios.doc(id).get();
    return Usuario.desdeDocumentSnapshot(documentSnapshot);
  }

  Future<void> registrarNuevo(Usuario nuevoUsuario) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: nuevoUsuario.email,
        password: nuevoUsuario.contrasena!,
      );

      nuevoUsuario.id = userCredential.user!.uid;
      await crear(nuevoUsuario);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('La contraseña es muy debil, debe contener numeros, letras y simbolos.');
      } else if (e.code == 'email-already-in-use') {
        print('Ya existe una cuenta para ese email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Usuario> autenticar(String email, String contrasena) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: contrasena
      );

      return await obtenerPorId(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('El correo no existe');
      } else if (e.code == 'wrong-password') {
        throw Exception('Contraseña incorrecta');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
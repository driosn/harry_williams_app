import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/core/bloc/usuarios/crear_usuario_bloc.dart';
import 'package:harry_williams_app/src/core/bloc/usuarios/usuario_bloc.dart';
import 'package:harry_williams_app/src/core/models/usuario.dart';
import 'package:harry_williams_app/src/core/services/usuarios_service.dart';
import 'package:harry_williams_app/src/ui/pages/principal/principal_page.dart';
import 'package:harry_williams_app/src/ui/pages/principal_paciente/principal_paciente_page.dart';
import 'package:harry_williams_app/src/utils/dialogs_carga.dart';
import 'package:harry_williams_app/src/utils/toast.dart';

class AutenticacionPage extends StatefulWidget {
  AutenticacionPage({ Key? key }) : super(key: key);

  @override
  State<AutenticacionPage> createState() => _AutenticacionPageState();
}

class _AutenticacionPageState extends State<AutenticacionPage> {
  final _usuariosService = UsuariosService();

  @override
  void initState() {
    super.initState();
    var usu = FirebaseAuth.instance.currentUser;

    if (usu != null) {
      print('Existe usuario');
      print(usu.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SeccionLogin(),
    );
  }
}

class SeccionLogin extends StatefulWidget {
  const SeccionLogin({ Key? key }) : super(key: key);

  @override
  _SeccionLoginState createState() => _SeccionLoginState();
}

class _SeccionLoginState extends State<SeccionLogin> {

  final _usuarioBloc = UsuarioBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 40
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              SizedBox(
                height: 160,
                width: 160,
                child: Image.asset('assets/imagenes/logo_harry_williams.jpeg'),
              ),
              const SizedBox(height: 40),
              TextField(
                decoration: const InputDecoration(
                  label: Text('Correo')
                ),
                onChanged: (valor) => _usuarioBloc.correoLogin = valor
              ),
              const SizedBox(height: 12),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text('Contraseña')
                ),
                onChanged: (valor) => _usuarioBloc.contrasenaLogin = valor,
              ),
              const SizedBox(height: 36),
              StreamBuilder(
                stream: _usuarioBloc.formLoginLlenadoCorrectamenteSteram,
                builder: (context, snapshot) {
                  final botonActivo = snapshot.hasData && snapshot.data == true;
                  return ElevatedButton(
                    child: Text('Ingresar'),
                    onPressed: botonActivo == false
                      ? null
                      : () async {
                          try {
                            DialogsCarga.mostrarCircular(context);
                            final usuario = await _usuarioBloc.autenticarCorreoYContrasena();
                            Navigator.pop(context);
                            if (usuario.rol == "PAC") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PrincipalPacientePage()
                                )
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PrincipalPage() 
                                )
                              );
                            }
                          } catch (e) {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: const Text('Usuario o contraseña incorrectos'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Aceptar'),
                                      onPressed: () => Navigator.pop(context),
                                    )
                                  ],
                                );
                              }
                            );
                          }
                        },
                  );
                },
              ),
              const SizedBox(height: 36),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SeccionRegistro()
                    )
                  );
                }, 
                child: const Text(
                  '¿No tienes cuenta?\nRegístrate',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  )
                )
              )
            ]
          ),
        ),
      ),
    );
  }
}

class SeccionRegistro extends StatefulWidget {
  const SeccionRegistro({ Key? key }) : super(key: key);

  @override
  _SeccionRegistroState createState() => _SeccionRegistroState();
}

class _SeccionRegistroState extends State<SeccionRegistro> {
  final _crearUsuarioBloc = CrearUsuarioBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear nueva cuenta'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 40
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: const InputDecoration(
                  label: Text('Nombre')
                ),
                onChanged: (valor) => _crearUsuarioBloc.nombre = valor,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  label: Text('Apellido')
                ),
                onChanged: (valor) => _crearUsuarioBloc.apellido = valor,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  label: Text('Nombre de usuario')
                ),
                onChanged: (valor) => _crearUsuarioBloc.nombreUsuario = valor,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  label: Text('Correo')
                ),
                onChanged: (valor) => _crearUsuarioBloc.correo = valor,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  label: Text('Contraseña')
                ),
                onChanged: (valor) => _crearUsuarioBloc.contrasena = valor,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  label: Text('Confirmar contraeña')
                ),
                onChanged: (valor) => _crearUsuarioBloc.confirmacionContrasena = valor,
              ),
              const SizedBox(height: 20),
              StreamBuilder(
                stream: _crearUsuarioBloc.formularioLlenadoCorrectamenteStream,
                builder: (context, snapshot) {
                  final botonActivo = snapshot.hasData && snapshot.data == true;
                  return ElevatedButton(
                    onPressed: botonActivo
                      ? _crearCuenta
                      : null,
                    child: Text('Crear cuenta')
                  );
                }
              )
            ],
          )
        ),
      )
    );
  }

  void _crearCuenta() async {
    try {
      DialogsCarga.mostrarCircular(context);
      await _crearUsuarioBloc.crearPaciente();
      Navigator.pop(context);
      Navigator.pop(context);
      Toast.mostrarCorrecto(mensaje: 'Cuenta creada correctamnete');
    } catch (e) {
      Navigator.pop(context);
      Toast.mostrarCorrecto(mensaje: 'No se pudo crear la cuenta');
    }
  }
}
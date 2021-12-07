import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harry_williams_app/src/ui/colores/colores.dart';
import 'package:harry_williams_app/src/ui/pages/autenticacion/autenticacion_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital Harry Williams',
      theme: ThemeData(
        primaryColor: const Color(0xffDF001D),
        colorScheme: const ColorScheme.light().copyWith(
          primary: colorPrimario
        ),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8)
          )
        )
      ),
      home: AutenticacionPage()
      // home: PrincipalPage()
    );
  }
}
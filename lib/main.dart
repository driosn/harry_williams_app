import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:harry_williams_app/src/ui/colores/colores.dart';
import 'package:harry_williams_app/src/ui/pages/principal/principal_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        primaryColor: const Color(0xffDF001D),
        colorScheme: ColorScheme.light().copyWith(
          primary: colorPrimario
        ),
      ),
      home: PrincipalPage()
    );

  }
}
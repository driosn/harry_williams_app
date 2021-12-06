import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toast {

  static void mostrarCorrecto({required String mensaje}) {
    Fluttertoast.showToast(
        msg: mensaje,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static void mostrarIncorrecto({required String mensaje}) {
    Fluttertoast.showToast(
        msg: mensaje,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}
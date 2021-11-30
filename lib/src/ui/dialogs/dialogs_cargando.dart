import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DialogsCargando {

  static mostrarSalud(BuildContext context) {
    showDialog(
      context: context, 
      builder: (context) {
        return Dialog(
          child: Center(
            child: LottieBuilder.asset('assets/lottie/health_loading.json'),
          ),
        );
      }
    );
  }


}
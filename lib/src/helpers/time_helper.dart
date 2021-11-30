import 'package:flutter/material.dart';

class TimeHelper {

  final TimeOfDay time;

  TimeHelper({required this.time});

  String formatearParaFirestore() {
    final hora = time.hour;
    final minuto = time.minute < 10
                    ? '0${time.minute}'
                    : time.minute;
    return '$hora$minuto';
  }
}
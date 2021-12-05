import 'package:flutter/material.dart';

class TimeHelper {
  static String aString(TimeOfDay time) {
    final hora = time.hour;
    final minuto = time.minute < 10
                    ? '0${time.minute}'
                    : time.minute;
    return '$hora:$minuto';
  }

  static TimeOfDay desdeString(String tiempo) {
    final hora = tiempo.split(':').first;
    final minuto = tiempo.split(':').last;
    return TimeOfDay.fromDateTime(DateTime(0, 1, 1, int.parse(hora), int.parse(minuto), 0));
  }
}
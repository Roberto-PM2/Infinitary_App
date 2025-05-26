import 'package:flutter/material.dart';

class Alerta {
  final String texto;
  final TimeOfDay hora;

  Alerta({required this.texto, required this.hora});

  // Convertir a Map para guardar en Hive
  Map<String, dynamic> toMap() {
    return {
      'texto': texto,
      'hora': {'hour': hora.hour, 'minute': hora.minute},
    };
  }

  // Crear desde Map al leer de Hive (con conversión segura)
  factory Alerta.fromMap(Map<dynamic, dynamic> map) {
    final horaMap = Map<String, dynamic>.from(map['hora']); // Conversión segura
    return Alerta(
      texto: map['texto'],
      hora: TimeOfDay(hour: horaMap['hour'], minute: horaMap['minute']),
    );
  }
}

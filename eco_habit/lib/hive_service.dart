import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';


class HiveService {
  static Future<void> cargarDatosInicialesDesdeJson() async {
    final box = await Hive.openBox('centros_reciclaje');

    // Si ya hay datos, no volver a cargarlos
    if (box.isNotEmpty) return;

    // 1. Cargar y decodificar el JSON (que es una lista)
    final jsonString = await rootBundle.loadString('assets/archivos/centro.json');
    final List<dynamic> centrosJson = json.decode(jsonString);

    // 2. Guardar cada centro en Hive usando su índice como clave
    for (int i = 0; i < centrosJson.length; i++) {
      await box.put(i, centrosJson[i]); // Guarda cada item con clave 0, 1, 2...
    }

    // Alternativa: Si cada centro tiene un "id" único, úsalo como clave:
    // for (final centro in centrosJson) {
    //   await box.put(centro['id'], centro);
    // }
  }
}
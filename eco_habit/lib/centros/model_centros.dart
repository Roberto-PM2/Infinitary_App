import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_route_service/open_route_service.dart';

class Centro {
  final String nombre;
  final String imagenUrl;
  final String direccion;
  final List<String> horarios;
  final String telefono;
  final double calificacion;
  final String ciudad;
  final double latitud;
  final double longitud;

  Centro({
    required this.nombre,
    required this.imagenUrl,
    required this.direccion,
    required this.horarios,
    required this.telefono,
    required this.calificacion,
    required this.ciudad,
    required this.latitud,
    required this.longitud,
  });

  factory Centro.fromMap(Map<String, dynamic> map) {
    return Centro(
      nombre: map['nombre'],
      imagenUrl: map['imagenUrl'],
      direccion: map['direccion'],
      horarios: List<String>.from(map['horarios']),
      telefono: map['telefono'],
      calificacion: (map['calificacion'] ?? 0).toDouble(),
      ciudad: map['ciudad'],
      latitud: (map['latitud'] ?? 0).toDouble(),
      longitud: (map['longitud'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'imagenUrl': imagenUrl,
      'direccion': direccion,
      'horarios': horarios,
      'telefono': telefono,
      'calificacion': calificacion,
      'ciudad': ciudad,
      'latitud': latitud,
      'longitud': longitud,
    };
  }

  /// Carga los centros desde Hive
  static Future<List<Centro>> cargarDesdeHive() async {
    final box = await Hive.openBox('centrosBox');
    final List<Centro> centros = [];

    for (var entry in box.values) {
      if (entry is Map<String, dynamic>) {
        centros.add(Centro.fromMap(entry));
      } else if (entry is Map) {
        centros.add(Centro.fromMap(Map<String, dynamic>.from(entry)));
      }
    }

    return centros;
  }

  static Future<List<LatLng>> getRuta({
    required LatLng inicio,
    required LatLng destino,
  }) async {
    final OpenRouteService client = OpenRouteService(
      apiKey: '5b3ce3597851110001cf6248bf25cc205ba643acb41ecc3798102060',
    );

    final List<ORSCoordinate> routeCoordinates =
        await client.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(
          latitude: inicio.latitude, longitude: inicio.longitude),
      endCoordinate: ORSCoordinate(
          latitude: destino.latitude, longitude: destino.longitude),
    );

    return routeCoordinates
        .map((coord) => LatLng(coord.latitude, coord.longitude))
        .toList();
  }
}

// Lista de centros de reciclaje
final List<Centro> centrosReciclaje = [
  Centro(
    nombre: 'Recicladora esquivel',
    imagenUrl: 'assets/images/recicladora_esquivel.png',
    direccion: 'Heroes de La Reforma 113 C, Estrella de Oro, 98087 Zacatecas, Zac.',
    horarios: [
      '9 a.m.–6 p.m.', // Lunes
      '9 a.m.–6 p.m.', // Martes
      '9 a.m.–6 p.m.', // Miércoles
      '9 a.m.–6 p.m.', // Jueves
      '9 a.m.–6 p.m.', // Viernes
      '9 a.m.–2 p.m.', // Sábado
      'Cerrado',       // Domingo
    ],
    telefono: '492 172 6002',
    calificacion: 5.0,
    ciudad: 'Zacatecas, Zacatecas',
    latitud: 22.756718,
    longitud: -102.597067,
  ),
  
  Centro(
    nombre: 'Reciclajes Revolución',
    imagenUrl: 'assets/images/reciclaje_revolucion.jpg',
    direccion: 'Calz. Revolución Mexicana 10, Ejidal, 98613 Guadalupe, Zac.',
    horarios: [
      '8:30 a.m.–5:30 p.m.', // Lunes
      '8:30 a.m.–5:30 p.m.', // Martes
      '8:30 a.m.–5:30 p.m.', // Miércoles
      '8:30 a.m.–5:30 p.m.', // Jueves
      '8:30 a.m.–5:30 p.m.', // Viernes
      '8:30 a.m.–2 p.m.',    // Sábado
      'Cerrado',              // Domingo
    ],
    telefono: '492 899 5892',
    calificacion: 5.0,
    ciudad: 'Guadalupe, Zacatecas',
    latitud: 22.751792812389258,
    longitud: -102.50051516221002,
  ),
  
  Centro(
    nombre: 'Reciclajes Miravalle',
    imagenUrl: 'assets/images/reciclaje_miravele.jpg',
    direccion: 'Carretera panamericana salida a Ags km 1 Entre bonito pueblo y, Villas de Guadalupe, 98613',
    horarios: [
      '8:30 a.m.–6 p.m.', // Lunes
      '8:30 a.m.–6 p.m.', // Martes
      '8:30 a.m.–6 p.m.', // Miércoles
      '8:30 a.m.–6 p.m.', // Jueves
      '8:30 a.m.–6 p.m.', // Viernes
      '8:30 a.m.–2 p.m.', // Sábado
      'Cerrado',           // Domingo
    ],
    telefono: '492 998 0906',
    calificacion: 4.3,
    ciudad: 'Guadalupe, Zacatecas',
    latitud: 22.751082,
    longitud: -102.486468,
  ),
];

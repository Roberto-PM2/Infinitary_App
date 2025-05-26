import 'package:flutter/material.dart';
import 'model_centros.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_route_service/open_route_service.dart';


class ControladorCentros extends ChangeNotifier {
  List<Centro> _centros = [];
  bool _cargando = false;

  List<Centro> get centros => _centros;
  bool get cargando => _cargando;

  Future<void> cargarCentros() async {
    _cargando = true;
    notifyListeners();

    _centros = centrosReciclaje;

    _cargando = false;
    notifyListeners();
  }


  //rutas de mapa
  List<LatLng> _puntosRuta = [];
  bool _cargandoMapa = false;

  List<LatLng> get puntosRuta => _puntosRuta;
  bool get cargandoMapa => _cargandoMapa;

  Future<List<LatLng>> solicitarRuta({
    required LatLng origen,
    required LatLng destino,
  }) async {
    try {
      final puntos = await Centro.getRuta(inicio: origen, destino: destino);
      return puntos;
    } catch (e) {
      print('Error al solicitar ruta: $e');
      return [];
    }
  }


  void limpiarRuta() {
    _puntosRuta = [];
    notifyListeners();
  }

}

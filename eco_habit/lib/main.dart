import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'home_page.dart';
import 'notifications_service.dart';

void main() async {

  //inicializar hive
  await Hive.initFlutter();

  //abrir la caja
  await Hive.openBox("ALERTAS");
  await Hive.openBox("Habitos");
  await Hive.openBox("Huella_anual");

  //habitos diarios
  await Hive.openBox("habitos_diarios");

  //agregar servicio de notificaciones:
  //await NotificationService().initialize();
  await NotificationService().initNotification(); // Inicializar notificaciones

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}


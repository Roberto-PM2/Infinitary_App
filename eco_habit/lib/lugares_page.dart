import 'package:flutter/material.dart';

class CentrosReciclaje extends StatefulWidget {
  const CentrosReciclaje({super.key});

  @override
  State<CentrosReciclaje> createState() => _CentrosReciclajeState();
}

class _CentrosReciclajeState extends State<CentrosReciclaje> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lugares"),
        backgroundColor: const Color(0xff368983),
      ),
    );
  }
}
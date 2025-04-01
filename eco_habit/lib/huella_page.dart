import 'package:flutter/material.dart';

class HuellaCarbono extends StatefulWidget {
  const HuellaCarbono({super.key});

  @override
  State<HuellaCarbono> createState() => _HuellaCarbonoState();
}

class _HuellaCarbonoState extends State<HuellaCarbono> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Huella de carbono"),
        backgroundColor: const Color(0xff368983),
      ),
    );
  }
}
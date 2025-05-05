import 'package:flutter/material.dart';
import 'huella_page.dart';
import 'registro_diario.dart'; // Este es el nuevo widget básico.

class HuellaMenu extends StatefulWidget {
  const HuellaMenu({super.key});

  @override
  State<HuellaMenu> createState() => _HuellaMenuState();
}

class _HuellaMenuState extends State<HuellaMenu> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HuellaCarbono(),
    RegistroDiarioPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Encuesta Anual',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Registro Diario',
          ),
        ],
      ),
    );
  }
}

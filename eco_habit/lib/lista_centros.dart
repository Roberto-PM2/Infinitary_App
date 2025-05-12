import 'package:flutter/material.dart';
import 'centros_model.dart';
import 'informacion_centro.dart';

class CentrosReciclaje extends StatelessWidget {
  const CentrosReciclaje({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Centros de Reciclaje"),
        backgroundColor: const Color(0xff368983),
      ),
      body: Column(
        children: [
          
          Expanded(
            child: ListView.builder(
              itemCount: centrosReciclaje.length,
              itemBuilder: (context, index) {
                final centro = centrosReciclaje[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(centro.imagenUrl),
                    ),
                    title: Text(centro.nombre),
                    subtitle: Text(centro.ciudad),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformacionCentro(centro: centro),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

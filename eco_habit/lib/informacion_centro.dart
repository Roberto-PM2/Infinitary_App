import 'package:flutter/material.dart';
import 'model_centros.dart';

class InformacionCentro extends StatefulWidget {
  final Centro centro;

  const InformacionCentro({super.key, required this.centro});

  @override
  _InformacionCentroState createState() => _InformacionCentroState();
}

class _InformacionCentroState extends State<InformacionCentro> {
  late List<String> _diasSemana;
  String? _diaSeleccionado;

  @override
  void initState() {
    super.initState();
    // Inicializar la lista de días con los valores del centro
    _diasSemana = [
      'Lunes '+widget.centro.lunes,
      'Martes '+widget.centro.martes,
      'Miércoles '+widget.centro.miercoles,
      'Jueves '+widget.centro.jueves,
      'Viernes '+widget.centro.viernes,
      'Sábado '+widget.centro.sabado,
      'Domingo '+widget.centro.domingo
    ];

    // Inicializar el día seleccionado (puedes elegir el primer valor o algún otro)
    _diaSeleccionado = _diasSemana[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.centro.nombre),
        backgroundColor: const Color(0xff368983),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen destacada
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(widget.centro.imagenUrl),
            ),
            const SizedBox(height: 20),

            // Nombre y calificación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      widget.centro.nombre,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text(
                      widget.centro.calificacion.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),


            const SizedBox(height: 20),

            // Dirección
            const Text('Dirección:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.centro.direccion, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 16),

            // Teléfono
            const Text('Teléfono:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              widget.centro.telefono,
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            ),

            const SizedBox(height: 20),

            // Horarios
            const Text('Horarios:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),

            // Dropdown Button para seleccionar el día de la semana
            DropdownButton<String>(
              value: _diaSeleccionado,
              onChanged: (String? newValue) {
                setState(() {
                  _diaSeleccionado = newValue!;
                });
              },
              items: _diasSemana.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

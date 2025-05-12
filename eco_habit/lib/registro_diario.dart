import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class RegistroDiarioPage extends StatefulWidget {
  const RegistroDiarioPage({super.key});

  @override
  State<RegistroDiarioPage> createState() => _RegistroDiarioPageState();
}

class _RegistroDiarioPageState extends State<RegistroDiarioPage> {
  final List<String> opciones = ['si', 'no'];
  final Map<String, double> valoresCO2 = {
    'vehiculo': 0.010,
    'transporte_publico': 0.004,
    'caminar_bici': 0.0,
    'carne_roja': 0.008,
    'plastico': 0.003,
    'reciclaje': -0.003,
    'compras': 0.010,
    'aire_ac': 0.007,
    'luces': 0.002,
    'botellas': 0.0015,
  };

  final Map<String, String> respuestas = {
    'vehiculo': 'no',
    'transporte_publico': 'no',
    'caminar_bici': 'no',
    'carne_roja': 'no',
    'plastico': 'no',
    'reciclaje': 'no',
    'compras': 'no',
    'aire_ac': 'no',
    'luces': 'no',
    'botellas': 'no',
  };

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Diario'),
      ),
      body: Column(
        children: [
          //grafica
          SizedBox(
            height: 250,
            child: ValueListenableBuilder(
              valueListenable: Hive.box('habitos_diarios').listenable(),
              builder: (context, Box box, _) {
                final registros = box.values.toList().cast<Map>();

                if (registros.isEmpty) {
                  return const Center(child: Text('Sin datos para graficar'));
                }

                final sorted = registros.map((r) {
                  final date = DateFormat('dd/MM/yyyy').parse(r['fecha']);
                  return {'fecha': date, 'consumo_diario': r['consumo_diario']};
                }).toList()
                  ..sort((a, b) => a['fecha'].compareTo(b['fecha']));

                final spots = sorted.asMap().entries.map((entry) {
                  return FlSpot(
                    entry.key.toDouble(),
                    (entry.value['consumo_diario'] as num).toDouble(),
                  );
                }).toList();

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toStringAsFixed(3),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false), // Oculta eje derecho
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= sorted.length) return const SizedBox();
                              final date = sorted[index]['fecha'] as DateTime;
                              return Text(
                                DateFormat('dd/MM').format(date),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false), // Oculta eje superior si no lo necesitas
                        ),
                      ),
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                '${spot.y.toStringAsFixed(3)} kg CO₂',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),


          const Divider(),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box('habitos_diarios').listenable(),
              builder: (context, Box box, _) {
                final registros = box.values.toList().cast<Map>();
                if (registros.isEmpty) {
                  return const Center(child: Text('No hay registros aún'));
                }
                //lista de registros
                return ListView.builder(
                  itemCount: registros.length,
                  itemBuilder: (context, index) {
                    final r = registros[index];
                    final double consumoActual = (r['consumo_diario'] as num).toDouble();

                    Icon consumoIcon;

                    if (index == 0) {
                      // Primer registro, no hay anterior para comparar
                      consumoIcon = const Icon(Icons.remove, color: Colors.grey);
                    } else {
                      final double consumoAnterior = (registros[index - 1]['consumo_diario'] as num).toDouble();
                      if (consumoActual < consumoAnterior) {
                        consumoIcon = const Icon(Icons.arrow_downward, color: Colors.green);
                      } else if (consumoActual > consumoAnterior) {
                        consumoIcon = const Icon(Icons.arrow_upward, color: Colors.red);
                      } else {
                        consumoIcon = const Icon(Icons.horizontal_rule, color: Colors.grey);
                      }
                    }

                    return ListTile(
                      leading: consumoIcon,
                      title: Text('Fecha: ${r['fecha']}'),
                      subtitle: Text('Consumo: ${consumoActual.toStringAsFixed(3)} Ton CO₂'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          box.deleteAt(index);
                        },
                      ),
                    );
                  },
                );

              },
            ),
          ),
        ],
      ),

      //Botones
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _confirmarEliminarTodo,
              icon: const Icon(Icons.delete_forever),
              label: const Text('Eliminar todo'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showRegistroPopup,
              icon: const Icon(Icons.add),
              label: const Text('Registro'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calcularConsumo() {
    double total = 0.0;
    respuestas.forEach((clave, valor) {
      if (valor == 'si') {
        total += valoresCO2[clave] ?? 0.0;
      }
    });
    return total;
  }

  String _preguntaTexto(String clave) {
    switch (clave) {
      case 'vehiculo': return '¿Usaste vehículo motorizado?';
      case 'transporte_publico': return '¿Tomaste transporte público?';
      case 'caminar_bici': return '¿Caminaste o usaste bici?';
      case 'carne_roja': return '¿Consumiste carne roja?';
      case 'plastico': return '¿Consumiste productos envasados en plástico?';
      case 'reciclaje': return '¿Reciclaste hoy?';
      case 'compras': return '¿Compraste artículos nuevos?';
      case 'aire_ac': return '¿Usaste aire acondicionado/calefacción?';
      case 'luces': return '¿Dejaste luces encendidas innecesariamente?';
      case 'botellas': return '¿Consumiste agua embotellada/bebidas desechables?';
      default: return clave;
    }
  }

  void _showRegistroPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStatePopup) {
            return AlertDialog(
              title: const Text('Nuevo registro de hábito'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var clave in respuestas.keys)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(child: Text(_preguntaTexto(clave))),
                            DropdownButton<String>(
                              value: respuestas[clave],
                              items: opciones.map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase()))).toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setStatePopup(() => respuestas[clave] = v);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final dt = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (dt != null) setStatePopup(() => _selectedDate = dt);
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 8),
                          Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final box = Hive.box('habitos_diarios');
                    final formatted = DateFormat('dd/MM/yyyy').format(_selectedDate);
                    final exists = box.values.cast<Map>().any((r) => r['fecha'] == formatted);

                    if (exists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ya existe un registro para $formatted')),
                      );
                    } else {
                      final consumo = _calcularConsumo();
                      final data = {
                        'fecha': formatted,
                        'consumo_diario': consumo,
                        ...respuestas,
                      };
                      box.add(data);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registro guardado')),
                      );
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmarEliminarTodo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Deseas eliminar todos los registros?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Hive.box('habitos_diarios').clear();
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar todo'),
            ),
          ],
        );
      },
    );
  }
}

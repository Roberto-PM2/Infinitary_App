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
  final _plasticoOptions = ['si', 'no'];
  String _plasticoValue = 'si';
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Diario'),
      ),
      body: Column(
        children: [
          // Aquí irá tu gráfica fl_chart
          SizedBox(
            height: 250,
            child: ValueListenableBuilder(
              valueListenable: Hive.box('habitos_diarios').listenable(),
              builder: (context, Box box, _) {
                final registros = box.values.toList().cast<Map>();

                if (registros.isEmpty) {
                  return const Center(child: Text('Sin datos para graficar'));
                }

                // Ordenar por fecha (usando DateTime real)
                final sorted = registros.map((r) {
                  final date = DateFormat('dd/MM/yyyy').parse(r['fecha']);
                  return {'fecha': date, 'consumo_diario': r['consumo_diario']};
                }).toList()
                  ..sort((a, b) => a['fecha'].compareTo(b['fecha']));

                final spots = sorted.asMap().entries.map((entry) {
                  return FlSpot(
                    entry.key.toDouble(), // X como índice
                    (entry.value['consumo_diario'] as num).toDouble(),
                  );
                }).toList();

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= sorted.length) return const SizedBox();
                              final date = sorted[index]['fecha'] as DateTime;
                              return Text(DateFormat('dd/MM').format(date), style: const TextStyle(fontSize: 10));
                            },
                          ),
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
          // Lista de registros
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box('habitos_diarios').listenable(),
              builder: (context, Box box, _) {
                final registros = box.values.toList().cast<Map>();
                if (registros.isEmpty) {
                  return const Center(child: Text('No hay registros aún'));
                }
                return ListView.builder(
                  itemCount: registros.length,
                  itemBuilder: (context, index) {
                    final r = registros[index];
                    return ListTile(
                      leading: Icon(
                        r['plasticos'] == 'si'
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: r['plasticos'] == 'si' ? Colors.green : Colors.grey,
                      ),
                      title: Text('Fecha: ${r['fecha']}'),
                      subtitle: Text('Consumo: ${r['consumo_diario']} kg CO₂'),
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón Eliminar Todo
          FloatingActionButton.extended(
            heroTag: 'deleteAll',
            onPressed: _confirmarEliminarTodo,
            icon: const Icon(Icons.delete_forever),
            label: const Text('Eliminar todo'),
          ),
          const SizedBox(height: 12),
          // Botón Registro
          FloatingActionButton.extended(
            heroTag: 'addRecord',
            onPressed: _showRegistroPopup,
            icon: const Icon(Icons.add),
            label: const Text('Registro'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  double _calcularConsumo(String plastico) {
    // Si compró plástico, huella = 0.003, sino 0
    return plastico == 'si' ? 0.003 : 0.0;
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
                    // Pregunta sí/no
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Text('¿Compraste empaques de plástico?'),
                        ),
                        DropdownButton<String>(
                          value: _plasticoValue,
                          items: _plasticoOptions.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setStatePopup(() => _plasticoValue = v);
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Selector de fecha
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
                      // Mostrar alerta de duplicado
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ya existe un registro para $formatted')),
                      );
                    } else {
                      final consumo = _calcularConsumo(_plasticoValue);
                      box.add({
                        'plasticos': _plasticoValue,
                        'fecha': formatted,
                        'consumo_diario': consumo,
                      });
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

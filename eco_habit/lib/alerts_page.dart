import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'alerta_model.dart'; // Asegúrate de importar tu modelo

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final mis_notificaciones = Hive.box("ALERTAS");
  final _textController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<Alerta> alertas_lista = [];

  @override
  void initState() {
    final lista = mis_notificaciones.get("LISTA_ALERTAS") ?? [];
    alertas_lista = lista.map<Alerta>((item) => Alerta.fromMap(item)).toList();
    super.initState();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void abrirIngresoInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Agregar Alerta"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Texto de la alerta'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Hora: '),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text(
                    _selectedTime.format(context),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _textController.clear();
            },
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              agregarInfo();
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  void agregarInfo() {
    String info = _textController.text;
    setState(() {
      alertas_lista.add(Alerta(texto: info, hora: _selectedTime));
      _textController.clear();
      _selectedTime = TimeOfDay.now(); // Resetear a la hora actual
    });
    saveToDatabase();
  }

  void deleteTodo(int index) {
    setState(() {
      alertas_lista.removeAt(index);
    });
    saveToDatabase();
  }

  void saveToDatabase() {
    final listaMap = alertas_lista.map((alerta) => alerta.toMap()).toList();
    mis_notificaciones.put("LISTA_ALERTAS", listaMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alertas"),
        backgroundColor: const Color(0xff368983),
      ),
      body: ListView.builder(
        itemCount: alertas_lista.length,
        itemBuilder: (context, index) {
          final alerta = alertas_lista[index];
          return ListTile(
            title: Text(alerta.texto),
            subtitle: Text(alerta.hora.format(context)),
            trailing: IconButton(
              onPressed: () => deleteTodo(index),
              icon: const Icon(Icons.delete),
            ),
          );
        },
      ),
      floatingActionButton: Container(
        width: 150,
        height: 100,
        child: FloatingActionButton(
          onPressed: abrirIngresoInfo,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.add),
              SizedBox(height: 5),
              Text(
                "Agregar nueva alerta",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
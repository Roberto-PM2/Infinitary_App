import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'alerta_model.dart'; // Asegúrate de importar tu modelo
import 'notifications_service.dart';

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
    _textController.clear();
    _selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
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
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedTime = picked;
                            });
                            setStateDialog(() {}); // Redibujar la ventana al ingresar una hora
                          }
                        },
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
                    if (_textController.text.trim().isEmpty) {
                      // Puedes mostrar un snackbar, toast o simplemente retornar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor ingresa un texto para la alerta')),
                      );
                      return;
                    }
                    Navigator.pop(context);
                    agregarAlerta();
                  },
                  child: const Text("Guardar"),
                ),
              ],
            );
          },
        );
      },
    );
  }


  // Agrega una nueva alerta
  void agregarAlerta() {
    String info = _textController.text;
    NotificationService().scheduleNotification(
      title: "Tu alerta",
      body: info,
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
    );
    setState(() {
      alertas_lista.add(Alerta(texto: info, hora: _selectedTime));
      _textController.clear();
      _selectedTime = TimeOfDay.now();
    });
    saveToDatabase();
  }

  // Edita una alerta existente
  void editarAlerta(int index) {
    final alerta = alertas_lista[index];
    _textController.text = alerta.texto;
    _selectedTime = alerta.hora;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Editar Alerta"),
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
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedTime = picked;
                            });
                            setStateDialog(() {}); // Redibuja el diálogo
                          }
                        },
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
                    if (_textController.text.trim().isEmpty) {
                      // Puedes mostrar un snackbar, toast o simplemente retornar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor ingresa un texto para la alerta')),
                      );
                      return;
                    }
                    NotificationService().scheduleNotification(
                      title: "Tu alerta",
                      body: _textController.text,
                      hour: _selectedTime.hour,
                      minute: _selectedTime.minute,
                    );
                    setState(() {
                      alertas_lista[index] = Alerta(
                        texto: _textController.text,
                        hora: _selectedTime,
                      );
                      _textController.clear();
                      _selectedTime = TimeOfDay.now();
                    });
                    saveToDatabase();
                  },
                  child: const Text("Guardar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Elimina una alerta
  void borrarAlerta(int index) {
    setState(() {
      alertas_lista.removeAt(index);
    });
    saveToDatabase();
  }

  // Guarda la lista en la base de datos Hive
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => editarAlerta(index),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => borrarAlerta(index),
                  icon: const Icon(Icons.delete),
                ),
              ],
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

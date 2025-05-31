import 'package:flutter/material.dart';
import 'modelo_meta.dart';
import 'crear_meta_page.dart';

class RegistrarMetaPage extends StatefulWidget {
  @override
  _RegistrarMetaPageState createState() => _RegistrarMetaPageState();
}

class _RegistrarMetaPageState extends State<RegistrarMetaPage> {
  DateTime selectedDate = DateTime.now();
  int weekOffset = 0;
  List<MetaPersonal> _metas = [];

  List<DateTime> _getWeekDays(DateTime baseDate) {
    final monday = baseDate.subtract(Duration(days: baseDate.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  List<MetaPersonal> get _metasFiltradas {
    return _metas.where((m) =>
      selectedDate.isAfter(m.inicio.subtract(Duration(days: 1))) &&
      selectedDate.isBefore(m.fin.add(Duration(days: 1)))).toList();
  }

  List<DateTime> get _fechasFin {
    return _metas.map((m) => m.fin).toList();
  }

  void _crearOModificarMeta({MetaPersonal? existente, int? index}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CrearMetaPage(metaExistente: existente),
      ),
    );
    if (resultado != null && resultado is MetaPersonal) {
      setState(() {
        if (index != null) {
          _metas[index] = resultado;
        } else {
          _metas.add(resultado);
        }
      });
    }
  }

  void _agregarProgreso(MetaPersonal meta, int index) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Agregar progreso"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: "¿Cuánto avanzaste hoy?"),
        ),
        actions: [
          TextButton(
            child: Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Guardar"),
            onPressed: () {
              final avance = double.tryParse(controller.text);
              if (avance != null && avance > 0) {
                setState(() {
                  final nuevoProgreso = _metas[index].progreso + avance;
                  _metas[index].progreso = nuevoProgreso > _metas[index].valor
                      ? _metas[index].valor
                      : nuevoProgreso;
                });
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    final semanaBase = DateTime.now().add(Duration(days: weekOffset * 7));
    final dias = _getWeekDays(semanaBase);

    return Scaffold(
      backgroundColor: Color(0xFFF5ECFF),
      appBar: AppBar(
        title: Text('Mis Metas'),
        backgroundColor: Color(0xFFF5ECFF),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () => setState(() => weekOffset--), icon: Icon(Icons.arrow_back_ios)),
              Text('Semana de ${_formatearFecha(dias.first)}', style: TextStyle(fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => setState(() => weekOffset++), icon: Icon(Icons.arrow_forward_ios)),
            ],
          ),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dias.length,
              itemBuilder: (context, index) {
                final dia = dias[index];
                final seleccionado = dia.day == selectedDate.day &&
                    dia.month == selectedDate.month &&
                    dia.year == selectedDate.year;
                final esFinMeta = _fechasFin.any((f) =>
                    f.day == dia.day && f.month == dia.month && f.year == dia.year);

                return GestureDetector(
                  onTap: () => setState(() => selectedDate = dia),
                  child: Container(
                    width: 65,
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: seleccionado ? Colors.purple[200] : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'][dia.weekday % 7],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: seleccionado ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: seleccionado ? Colors.white : Colors.grey.shade200,
                              child: Text(
                                dia.day.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: seleccionado ? Colors.purple : Colors.black,
                                ),
                              ),
                            ),
                            if (esFinMeta)
                              Positioned(
                                bottom: 2,
                                right: 4,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: _metasFiltradas.isEmpty
                ? Center(child: Text('No hay metas para este día'))
                : ListView.builder(
                    itemCount: _metasFiltradas.length,
                    itemBuilder: (context, index) {
                      final meta = _metasFiltradas[index];
                      final realIndex = _metas.indexOf(meta);
                      final porcentaje = meta.progreso / meta.valor;
                      final completada = meta.progreso >= meta.valor;

                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: () => _crearOModificarMeta(existente: meta, index: realIndex),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Text(
                                  meta.emoji, style: TextStyle(fontSize: 24),),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(meta.titulo,
                                          style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                    if (!completada)
                                      Container(
                                        margin: EdgeInsets.only(left: 8),
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Meta en curso',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green[800],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    if (completada)
                                      Container(
                                        margin: EdgeInsets.only(left: 8),
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.teal[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Completada',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.teal[800],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${meta.valor} ${meta.unidad}'),
                                    Text('Del ${_formatearFecha(meta.inicio)} al ${_formatearFecha(meta.fin)}'),
                                  ],
                                ),
                                trailing: Icon(Icons.edit),
                              ),
                              SizedBox(height: 6),
                              LinearProgressIndicator(
                                value: porcentaje > 1 ? 1 : porcentaje,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                minHeight: 6,
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${meta.progreso.toStringAsFixed(2)} / ${meta.valor.toStringAsFixed(2)} ${meta.unidad}',
                                      style: TextStyle(fontSize: 12)),
                                  if (!completada)
                                    TextButton(
                                      onPressed: () => _agregarProgreso(meta, realIndex),
                                      child: Text("Agregar progreso"),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _crearOModificarMeta(),
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }
}
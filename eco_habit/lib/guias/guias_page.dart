import 'package:flutter/material.dart';
import 'guias_model.dart';
import 'infomacion_guia.dart';


class GuiasPage extends StatefulWidget {
  const GuiasPage({super.key});

  @override
  State<GuiasPage> createState() => _GuiasPageState();
}

class _GuiasPageState extends State<GuiasPage> {
  final List<String> categorias = [
    'organico',
    'inorganico',
    'otros',
  ];
  final List<String> subcategorias = ['papel', 'plastico', 'alimentos', 'otros'];
  String? filtroCategoria;
  String? filtroSubcategoria;

  @override
  Widget build(BuildContext context) {
    // Lógica de filtrado mejorada
    final guiasFiltradas = _filtrarGuias();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guías de Reciclaje'),
        backgroundColor: const Color(0xff368983),
      ),
      body: Column(
        children: [
          // Filtro de categorías
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final cat = categorias[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: filtroCategoria == cat,
                    onSelected: (selected) {
                      setState(() {
                        filtroCategoria = selected ? cat : null;
                      });
                    },
                    selectedColor: Colors.green.shade300,
                    backgroundColor: Colors.grey.shade200,
                  ),
                );
              },
            ),
          ),

          // Filtro de subcategorías
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subcategorias.length, // Corregido: usar subcategorias.length
              itemBuilder: (context, index) {
                final subcat = subcategorias[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: ChoiceChip(
                    label: Text(subcat),
                    selected: filtroSubcategoria == subcat,
                    onSelected: (selected) {
                      setState(() {
                        filtroSubcategoria = selected ? subcat : null;
                      });
                    },
                    selectedColor: Colors.blue.shade300, // Color diferente para distinguir
                    backgroundColor: Colors.grey.shade200,
                  ),
                );
              },
            ),
          ),

          // Botones para limpiar filtros
          if (filtroCategoria != null || filtroSubcategoria != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (filtroCategoria != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        filtroCategoria = null;
                      });
                    },
                    child: const Text('Limpiar categoría'),
                  ),
                if (filtroSubcategoria != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        filtroSubcategoria = null;
                      });
                    },
                    child: const Text('Limpiar subcategoría'),
                  ),
              ],
            ),

          Expanded(
            child: guiasFiltradas.isEmpty
                ? const Center(
                    child: Text(
                      'No hay guías disponibles en esta categoría.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: guiasFiltradas.length,
                    itemBuilder: (context, index) {
                      final guia = guiasFiltradas[index];
                      return Card(
                        margin: const EdgeInsets.all(12),
                        child: ListTile(
                          leading: Image.asset(guia.imagenUrl, width: 50, fit: BoxFit.cover),
                          title: Text(guia.titulo),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(guia.descripcion),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(guia.categoria),
                                    backgroundColor: Colors.green.shade100,
                                  ),
                                  const SizedBox(width: 4),
                                  Chip(
                                    label: Text(guia.subcategoria),
                                    backgroundColor: Colors.blue.shade100,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InformacionGuia(guia: guia),
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

  List<Guia> _filtrarGuias() {
    // Caso 1: Ningún filtro seleccionado
    if (filtroCategoria == null && filtroSubcategoria == null) {
      return listaGuias;
    }
    // Caso 2: Solo categoría seleccionada
    else if (filtroCategoria != null && filtroSubcategoria == null) {
      return listaGuias.where((g) => g.categoria == filtroCategoria).toList();
    }
    // Caso 3: Solo subcategoría seleccionada
    else if (filtroCategoria == null && filtroSubcategoria != null) {
      return listaGuias.where((g) => g.subcategoria == filtroSubcategoria).toList();
    }
    // Caso 4: Ambos filtros seleccionados
    else {
      return listaGuias
          .where((g) => g.categoria == filtroCategoria && g.subcategoria == filtroSubcategoria)
          .toList();
    }
  }
}
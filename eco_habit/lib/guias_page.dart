import 'package:flutter/material.dart';
import 'model_guias.dart';

class GuiasPage extends StatefulWidget {
  const GuiasPage({super.key});

  @override
  State<GuiasPage> createState() => _GuiasPageState();
}

class _GuiasPageState extends State<GuiasPage> {
  final List<String> categorias = [
    'orgánico',
    'inorgánico',
    'papel',
    'metal',
    'cartón',
    'estilo de vida'
  ];
  final List<String> subcategorias = ['a', 'b', 'c'];
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
            child: ListView.builder(
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
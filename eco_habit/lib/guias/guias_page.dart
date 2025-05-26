import 'package:flutter/material.dart';
import 'model_guias.dart';
import 'infomacion_guia.dart';
import 'controlador_guias.dart'; // Importa el nuevo controlador


class GuiasPage extends StatefulWidget {
  const GuiasPage({super.key});

  @override
  State<GuiasPage> createState() => _GuiasPageState();
}

class _GuiasPageState extends State<GuiasPage> {
  final List<String> categorias = ['organico', 'inorganico', 'otros'];
  final List<String> subcategorias = ['papel', 'plastico', 'alimentos', 'otros'];
  String? filtroCategoria;
  String? filtroSubcategoria;

  late ControladorGuias _controlador;
  bool _isLoading = true;

  //antiguo init usar este para cargar guias metodo anterior
  /* @override
  void initState() {
    super.initState();
    _controlador = ControladorGuias(listaInicial: listaGuias); 
  } */

  @override
  void initState() {
    super.initState();
    _cargarGuiasDesdeFirebase();
  }

  //comentar esto en caso de que se quiera usar metodo anterior
  void _cargarGuiasDesdeFirebase() async {
    final guiasFirebase = await Guia.cargarDesdeFirebase();
    setState(() {
      _controlador = ControladorGuias(listaInicial: guiasFirebase);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //comentar esto para usar metodo anterior
    if (_isLoading) {
      return Center(child: CircularProgressIndicator()); // o cualquier pantalla de carga
    }

    final guiasFiltradas = _controlador.filtrarGuias(
      categoria: filtroCategoria,
      subcategoria: filtroSubcategoria,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guías de Reciclaje'),
        backgroundColor: const Color(0xff368983),
      ),
      body: Column(
        children: [
          // Filtros y botones como ya los tienes
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
          // Listado de guías
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
}

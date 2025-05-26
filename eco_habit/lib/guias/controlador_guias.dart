import 'model_guias.dart';

class ControladorGuias {
  final List<Guia> _todasLasGuias;

  ControladorGuias({required List<Guia> listaInicial}) : _todasLasGuias = listaInicial;

  List<Guia> filtrarGuias({String? categoria, String? subcategoria}) {
    if (categoria == null && subcategoria == null) {
      return _todasLasGuias;
    } else if (categoria != null && subcategoria == null) {
      return _todasLasGuias.where((g) => g.categoria == categoria).toList();
    } else if (categoria == null && subcategoria != null) {
      return _todasLasGuias.where((g) => g.subcategoria == subcategoria).toList();
    } else {
      return _todasLasGuias
          .where((g) => g.categoria == categoria && g.subcategoria == subcategoria)
          .toList();
    }
  }
}

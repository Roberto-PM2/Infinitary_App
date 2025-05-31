import 'modelo_meta.dart';

class ControladorMeta {
  final List<MetaPersonal> _metas = [];

  void registrarMeta(MetaPersonal meta) {
    _metas.add(meta);
  }

  List<MetaPersonal> obtenerMetas() => _metas;

  void eliminarMeta(int index) {
    if (index >= 0 && index < _metas.length) {
      _metas.removeAt(index);
    }
  }
}

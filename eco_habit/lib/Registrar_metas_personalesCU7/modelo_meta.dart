class MetaPersonal {
  final String titulo;
  final String tipo;
  final double valor;
  final String unidad;
  final DateTime inicio;
  final DateTime fin;
  final String emoji; 

  double progreso;

  MetaPersonal({
    required this.titulo,
    required this.tipo,
    required this.valor,
    required this.unidad,
    required this.inicio,
    required this.fin,
    required this.emoji,
    this.progreso = 0,
  });
}

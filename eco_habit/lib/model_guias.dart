class Guia {
  final String titulo;
  final String descripcion;
  final String categoria; // Ej: 'orgánico', 'inorgánico', 'papel', etc.
  final String subcategoria; // Nueva propiedad: 'a', 'b' o 'c'
  final String imagenUrl;

  Guia({
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.subcategoria,
    required this.imagenUrl,
  });
}

final List<Guia> listaGuias = [
  Guia(
    titulo: 'Cómo separar residuos orgánicos',
    descripcion: 'Aprende a distinguir entre restos de comida, hojas y residuos compostables.',
    categoria: 'orgánico',
    subcategoria: 'a',
    imagenUrl: 'assets/images/placeholder.png',
  ),
  Guia(
    titulo: 'Compostaje en casa',
    descripcion: 'Guía paso a paso para crear tu propio compost.',
    categoria: 'orgánico',
    subcategoria: 'b',
    imagenUrl: 'assets/images/placeholder.png',
  ),
  Guia(
    titulo: 'Guía para reciclar papel correctamente',
    descripcion: 'Consejos para separar papel limpio y doblarlo para facilitar su reciclaje.',
    categoria: 'papel',
    subcategoria: 'a',
    imagenUrl: 'assets/images/placeholder.png',
  ),
  Guia(
    titulo: 'Reducir el uso de plásticos',
    descripcion: 'Opciones reutilizables y hábitos sostenibles para evitar plásticos.',
    categoria: 'estilo de vida',
    subcategoria: 'c',
    imagenUrl: 'assets/images/placeholder.png',
  ),
  // Agrega más guías...
];
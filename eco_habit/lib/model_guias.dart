class Guia {
  final String titulo;
  final String descripcion;
  final String categoria;
  final String subcategoria;
  final String imagenUrl;
  final List<String> pasos; // Nuevo campo

  Guia({
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.subcategoria,
    required this.imagenUrl,
    required this.pasos,
  });
}

final List<Guia> listaGuias = [
  Guia(
    titulo: 'Cómo separar residuos orgánicos',
    descripcion: 'Aprende a distinguir entre restos de comida, hojas y residuos compostables.',
    categoria: 'organico',
    subcategoria: 'otros',
    imagenUrl: 'assets/images/placeholder.png',
    pasos: [
      'Identifica los restos de comida y hojas.',
      'Coloca estos residuos en un recipiente especial para orgánicos.',
      'Evita mezclar con plásticos u otros materiales.',
    ],
  ),
  Guia(
    titulo: 'Compostaje en casa',
    descripcion: 'Guía paso a paso para crear tu propio compost.',
    categoria: 'inorganico',
    subcategoria: 'alimentos',
    imagenUrl: 'assets/images/placeholder.png',
    pasos: [
      'Consigue un contenedor de compost.',
      'Añade capas de materiales verdes (restos de frutas, vegetales) y marrones (hojas secas, cartón).',
      'Revuelve semanalmente.',
      'Espera 2-3 meses para obtener compost natural.',
    ],
  ),
  // Agrega más guías con pasos
];

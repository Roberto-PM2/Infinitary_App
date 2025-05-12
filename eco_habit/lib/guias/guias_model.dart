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
    imagenUrl: 'assets/images/basura_tipo.jpg',
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
    imagenUrl: 'assets/images/composta.png',
    pasos: [
      'Consigue un contenedor de compost.',
      'Añade capas de materiales verdes (restos de frutas, vegetales) y marrones (hojas secas, cartón).',
      'Revuelve semanalmente.',
      'Espera 2-3 meses para obtener compost natural.',
    ],
  ),

  // Agrega más guías con pasos
  Guia(
    titulo: 'Separación de papel reciclable',
    descripcion: 'Conoce qué tipos de papel se pueden reciclar y cómo prepararlos correctamente.',
    categoria: 'inorganico',
    subcategoria: 'papel',
    imagenUrl: 'assets/images/papel.jpg',
    pasos: [
      'Separa hojas, periódicos, revistas y cuadernos sin grapas ni espirales.',
      'Evita papeles sucios con comida o grasa (no son reciclables).',
      'Aplana las cajas y organiza en pilas o bolsas limpias.',
      'Lleva el papel a un centro de reciclaje o colócalo en el contenedor azul si existe.',
    ],
  ),

  Guia(
    titulo: 'Reciclaje correcto de botellas plásticas',
    descripcion: 'Aprende a preparar botellas PET para su reciclaje sin contaminar otros materiales.',
    categoria: 'inorganico',
    subcategoria: 'plastico',
    imagenUrl: 'assets/images/botellas.png',
    pasos: [
      'Enjuaga las botellas para eliminar residuos de bebidas o alimentos.',
      'Retira las etiquetas si es posible.',
      'Aplasta las botellas para ahorrar espacio.',
      'Coloca las tapas por separado o revisa si pueden ir con el mismo plástico.',
    ],
  ),

  Guia(
    titulo: 'Gestión de residuos de alimentos',
    descripcion: 'Reduce desperdicios aprendiendo a clasificar y reutilizar restos de comida.',
    categoria: 'organico',
    subcategoria: 'alimentos',
    imagenUrl: 'assets/images/alimentos.jpg',
    pasos: [
      'Separa cáscaras, restos de frutas y verduras, cáscaras de huevo y posos de café.',
      'Evita incluir carne o productos lácteos en compostaje casero.',
      'Utiliza los residuos para compost o entrega en puntos de recolección orgánica.',
      'Limpia los recipientes de almacenamiento frecuentemente.',
    ],
  ),

  Guia(
    titulo: 'Cambios de estilo de vida para menos residuos',
    descripcion: 'Pequeñas acciones diarias que reducen tu impacto ambiental de forma efectiva.',
    categoria: 'otros',
    subcategoria: 'otros',
    imagenUrl: 'assets/images/vida.jpg',
    pasos: [
      'Usa bolsas reutilizables y botellas recargables.',
      'Compra productos a granel o con envases reciclables.',
      'Repara en lugar de desechar objetos dañados.',
      'Participa en campañas locales de reciclaje o limpiezas comunitarias.',
    ],
  ),




];

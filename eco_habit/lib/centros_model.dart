class Centro {
  final String nombre;
  final String imagenUrl;
  final String direccion;
  final List<String> horarios; // Lista de horarios de la semana
  final String telefono;
  final double calificacion;
  final String ciudad;
  final double latitud;
  final double longitud;

  Centro({
    required this.nombre,
    required this.imagenUrl,
    required this.direccion,
    required this.horarios, // Cambiado a lista
    required this.telefono,
    required this.calificacion,
    required this.ciudad,
    required this.latitud,
    required this.longitud,
  });
}

// Lista de centros de reciclaje
// Lista de centros de reciclaje
final List<Centro> centrosReciclaje = [
  Centro(
    nombre: 'Recicladora esquivel',
    imagenUrl: 'assets/images/recicladora_esquivel.png',
    direccion: 'Heroes de La Reforma 113 C, Estrella de Oro, 98087 Zacatecas, Zac.',
    horarios: [
      '9 a.m.–6 p.m.', // Lunes
      '9 a.m.–6 p.m.', // Martes
      '9 a.m.–6 p.m.', // Miércoles
      '9 a.m.–6 p.m.', // Jueves
      '9 a.m.–6 p.m.', // Viernes
      '9 a.m.–2 p.m.', // Sábado
      'Cerrado',       // Domingo
    ],
    telefono: '492 172 6002',
    calificacion: 5.0,
    ciudad: 'Zacatecas, Zacatecas',
    latitud: 22.756718,
    longitud: -102.597067,
  ),
  
  Centro(
    nombre: 'Reciclajes Revolución',
    imagenUrl: 'assets/images/reciclaje_revolucion.jpg',
    direccion: 'Calz. Revolución Mexicana 10, Ejidal, 98613 Guadalupe, Zac.',
    horarios: [
      '8:30 a.m.–5:30 p.m.', // Lunes
      '8:30 a.m.–5:30 p.m.', // Martes
      '8:30 a.m.–5:30 p.m.', // Miércoles
      '8:30 a.m.–5:30 p.m.', // Jueves
      '8:30 a.m.–5:30 p.m.', // Viernes
      '8:30 a.m.–2 p.m.',    // Sábado
      'Cerrado',              // Domingo
    ],
    telefono: '492 899 5892',
    calificacion: 5.0,
    ciudad: 'Guadalupe, Zacatecas',
    latitud: 22.751792812389258,
    longitud: -102.50051516221002,
  ),
  
  Centro(
    nombre: 'Reciclajes Miravalle',
    imagenUrl: 'assets/images/reciclaje_miravele.jpg',
    direccion: 'Carretera panamericana salida a Ags km 1 Entre bonito pueblo y, Villas de Guadalupe, 98613',
    horarios: [
      '8:30 a.m.–6 p.m.', // Lunes
      '8:30 a.m.–6 p.m.', // Martes
      '8:30 a.m.–6 p.m.', // Miércoles
      '8:30 a.m.–6 p.m.', // Jueves
      '8:30 a.m.–6 p.m.', // Viernes
      '8:30 a.m.–2 p.m.', // Sábado
      'Cerrado',           // Domingo
    ],
    telefono: '492 998 0906',
    calificacion: 4.3,
    ciudad: 'Guadalupe, Zacatecas',
    latitud: 22.751082,
    longitud: -102.486468,
  ),
];

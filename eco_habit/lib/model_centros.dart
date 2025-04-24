class Centro {
  final String nombre;
  final String imagenUrl;
  final String direccion;
  final String lunes; // Horario del lunes
  final String martes; // Horario del martes
  final String miercoles; // Horario del miércoles
  final String jueves; // Horario del jueves
  final String viernes; // Horario del viernes
  final String sabado; // Horario del sábado
  final String domingo; // Horario del domingo
  final String telefono;
  final double calificacion;
  final String ciudad;
  final double latitud;
  final double longitud;


  Centro({
    required this.nombre,
    required this.imagenUrl,
    required this.direccion,
    required this.lunes,
    required this.martes,
    required this.miercoles,
    required this.jueves,
    required this.viernes,
    required this.sabado,
    required this.domingo,
    required this.telefono,
    required this.calificacion,
    required this.ciudad,
    required this.latitud,
    required this.longitud,
  });
}

// Lista de centros de reciclaje
final List<Centro> centrosReciclaje = [
  Centro(
    nombre: 'Recicladora esquivel',
    imagenUrl: 'assets/images/recicladora_esquivel.png',
    direccion: 'Heroes de La Reforma 113 C, Estrella de Oro, 98087 Zacatecas, Zac.',
    lunes: '9 a.m.–6 p.m.',
    martes: '9 a.m.–6 p.m.',
    miercoles: '9 a.m.–6 p.m.',
    jueves: '9 a.m.–6 p.m.',
    viernes: '9 a.m.–6 p.m.',
    sabado: '9 a.m.–2 p.m.',
    domingo: 'Cerrado',
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
    lunes: '8:30 a.m.–5:30 p.m.',
    martes: '8:30 a.m.–5:30 p.m.',
    miercoles: '8:30 a.m.–5:30 p.m.',
    jueves: '8:30 a.m.–5:30 p.m.',
    viernes: '8:30 a.m.–5:30 p.m.',
    sabado: '8:30 a.m.–2 p.m.',
    domingo: 'Cerrado',
    telefono: '492 899 5892',
    calificacion: 5.0,
    ciudad: 'Guadalupe, Zacatecas',
    latitud: 22.751792812389258,
    longitud: -102.50051516221002,
  ),
  
  Centro(
    nombre: 'Reciclajes Miravalle',
    imagenUrl: 'assets/images/reciclaje_miravele.jpg',
    direccion: 'Carretera panamericana salida a Ags km 1 Entre bonito pueblo y, Villas de Guadalupe, 98613 ',
    lunes: '8:30 a.m.–6 p.m.',
    martes: '8:30 a.m.–6 p.m.',
    miercoles: '8:30 a.m.–6 p.m.',
    jueves: '8:30 a.m.–6 p.m.',
    viernes: '8:30 a.m.–6 p.m.',
    sabado: '8:30 a.m.–2 p.m.',
    domingo: 'Cerrado',
    telefono: '492 998 0906',
    calificacion: 4.3,
    ciudad: 'Guadalupe, Zacatecas',
    latitud: 22.751082,
    longitud: -102.486468,
  ),

];

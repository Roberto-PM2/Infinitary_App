import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'widgets/question_widget.dart';
import 'widgets/result_widget.dart';

class HuellaCarbono extends StatefulWidget {
  const HuellaCarbono({super.key});

  @override
  State<HuellaCarbono> createState() => _HuellaCarbonoState();
}

class _HuellaCarbonoState extends State<HuellaCarbono> {
  // Lista de preguntas
  final List<Map<String, dynamic>> _questions = [
    {
      'id': 'km_auto',
      'text': '¿Cuántos km recorres en auto a la semana?',
      'type': 'double',
    },
    {
      'id': 'consumo_auto',
      'text': '¿Cuántos km/l consume tu auto?',
      'type': 'double',
    },
    {
      'id': 'km_transporte_publico',
      'text': '¿Cuántos km usas transporte público a la semana?',
      'type': 'double',
    },
    {
      'id': 'electricidad',
      'text': '¿Cuántos kWh consumes al mes en tu hogar?',
      'type': 'double',
    },
    {
      'id': 'gas',
      'text': '¿Cuántos m³ de gas consumes al mes?',
      'type': 'double',
    },
    {
      'id': 'agua',
      'text': '¿Cuántos litros de agua consumes al día?',
      'type': 'double',
    },
    {
      'id': 'carne',
      'text': '¿Cuántos días a la semana comes carne roja?',
      'type': 'int',
    },
    {
      'id': 'lacteos',
      'text': '¿Cuántos días a la semana consumes lácteos?',
      'type': 'int',
    },
    {
      'id': 'vegano',
      'text': '¿Sigues una dieta vegana?',
      'type': 'bool',
    },
    {
      'id': 'ropa',
      'text': '¿Cuántas prendas de ropa compras al mes?',
      'type': 'int',
    },
    {
      'id': 'electronicos',
      'text': '¿Cuántos dispositivos electrónicos compras al año?',
      'type': 'int',
    },
    {
      'id': 'viajes_avion',
      'text': '¿Cuántos vuelos de más de 3 horas haces al año?',
      'type': 'int',
    },
  ];

  final Map<String, String> _responses = {};
  int _currentQuestionIndex = 0;
  bool _quizStarted = false;
  bool _quizFinished = false;
  double _huellaTotal = 0;

  // Referencias a las cajas de Hive
  late Box habitosBox;
  late Box huellaBox;

  @override
  void initState() {
    super.initState();
    habitosBox = Hive.box("Habitos");
    huellaBox = Hive.box("Huella_anual");

    // Verificamos si ya existe un resultado guardado
    final storedHuella = huellaBox.get("resultado");
    if (storedHuella != null) {
      _huellaTotal = storedHuella;
      _quizFinished = true;
      _quizStarted = true;
    }
  }

  void _startQuiz() {
    setState(() {
      _quizStarted = true;
      _currentQuestionIndex = 0;
      _responses.clear();
      _quizFinished = false;
    });
  }

  // Se espera que el widget question_widget llame a onSubmit con la respuesta (string)
  void _submitAnswer(String answer) {
    final currentQuestion = _questions[_currentQuestionIndex];
    _responses[currentQuestion['id']] = answer;

    setState(() {
      _currentQuestionIndex++;
      if (_currentQuestionIndex >= _questions.length) {
        _calculateHuella();
        _quizFinished = true;
        // Guardar los resultados en Hive
        huellaBox.put("resultado", _huellaTotal);
        habitosBox.put("respuestas", _responses);
      }
    });
  }

  void _calculateHuella() {
    double kmAuto = double.tryParse(_responses['km_auto'] ?? '0') ?? 0;
    double consumoAuto = double.tryParse(_responses['consumo_auto'] ?? '0') ?? 0;
    double kmTransporte = double.tryParse(_responses['km_transporte_publico'] ?? '0') ?? 0;
    double electricidad = double.tryParse(_responses['electricidad'] ?? '0') ?? 0;
    double gas = double.tryParse(_responses['gas'] ?? '0') ?? 0;
    double agua = double.tryParse(_responses['agua'] ?? '0') ?? 0;
    int carne = int.tryParse(_responses['carne'] ?? '0') ?? 0;
    int lacteos = int.tryParse(_responses['lacteos'] ?? '0') ?? 0;
    bool vegano = (_responses['vegano']?.toLowerCase() == 'sí' ||
        _responses['vegano']?.toLowerCase() == 's');
    int ropa = int.tryParse(_responses['ropa'] ?? '0') ?? 0;
    int electronicos = int.tryParse(_responses['electronicos'] ?? '0') ?? 0;
    int vuelos = int.tryParse(_responses['viajes_avion'] ?? '0') ?? 0;

    double huellaAuto = (consumoAuto > 0)
        ? (kmAuto * 52 / consumoAuto) * 2.31 / 1000
        : 0;
    double huellaTransporte = (kmTransporte * 52 * 0.1) / 1000;
    double huellaElectricidad = (electricidad * 12 * 0.4) / 1000;
    double huellaGas = (gas * 12 * 2) / 1000;
    double huellaAgua = (agua * 365 * 0.0003);
    double huellaCarne = (carne > 0) ? (carne * 52 * 0.05) : 0;
    double huellaLacteos = (lacteos > 0) ? (lacteos * 52 * 0.02) : 0;
    double huellaRopa = (ropa * 12 * 0.025);
    double huellaElectronicos = (electronicos * 0.5);
    double huellaVuelos = (vuelos * 1.1);

    double total = huellaAuto +
        huellaTransporte +
        huellaElectricidad +
        huellaGas +
        huellaAgua +
        huellaCarne +
        huellaLacteos +
        huellaRopa +
        huellaElectronicos +
        huellaVuelos;

    if (vegano) {
      total *= 0.8;
    }

    _huellaTotal = total;
  }

  void _restartQuiz() {
    setState(() {
      _quizStarted = false;
      _quizFinished = false;
      _responses.clear();
      _currentQuestionIndex = 0;
      _huellaTotal = 0;
      // Opcional: limpiar datos guardados en Hive
      huellaBox.delete("resultado");
      habitosBox.delete("respuestas");
    });
  }

  @override
  Widget build(BuildContext context) {
    // Si no se ha iniciado el cuestionario y no hay resultado guardado,
    // mostramos la pantalla de inicio.
    if (!_quizStarted) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Huella de Carbono"),
          backgroundColor: const Color(0xff368983),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "inicie nuestro cuestionario para calcular su huella de carbono anual.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startQuiz,
                child: const Text("Comenzar cuestionario"),
              ),
            ],
          ),
        ),
      );
    }


    // Si el cuestionario se ha finalizado (ya sea recién calculado o cargado de la base de datos)
    if (_quizFinished) {
      return ResultWidget(
        huellaTotal: _huellaTotal,
        onRestart: _restartQuiz,
      );
    }

    // Si se está en medio del cuestionario, mostramos la pregunta actual.
    return Scaffold(
      body: QuestionWidget(
        question: _questions[_currentQuestionIndex],
        onSubmit: _submitAnswer,
      ),
    );
  }
}

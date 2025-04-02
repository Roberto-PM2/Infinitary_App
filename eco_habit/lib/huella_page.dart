import 'package:flutter/material.dart';
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

  void _startQuiz() {
    setState(() {
      _quizStarted = true;
      _currentQuestionIndex = 0;
      _responses.clear();
      _quizFinished = false;
    });
  }

  void _submitAnswer(String answer) {
    final currentQuestion = _questions[_currentQuestionIndex];
    _responses[currentQuestion['id']] = answer;

    setState(() {
      _currentQuestionIndex++;
      if (_currentQuestionIndex >= _questions.length) {
        _calculateHuella();
        _quizFinished = true;
      }
    });
  }

  void _calculateHuella() {
    // Se parsean las respuestas a números según corresponda
    double kmAuto = double.tryParse(_responses['km_auto'] ?? '0') ?? 0;
    double consumoAuto = double.tryParse(_responses['consumo_auto'] ?? '0') ?? 0;
    double kmTransporte = double.tryParse(_responses['km_transporte_publico'] ?? '0') ?? 0;
    double electricidad = double.tryParse(_responses['electricidad'] ?? '0') ?? 0;
    double gas = double.tryParse(_responses['gas'] ?? '0') ?? 0;
    double agua = double.tryParse(_responses['agua'] ?? '0') ?? 0;
    int carne = int.tryParse(_responses['carne'] ?? '0') ?? 0;
    int lacteos = int.tryParse(_responses['lacteos'] ?? '0') ?? 0;
    // Para la pregunta vegana, interpretamos "sí" como verdadero
    bool vegano = (_responses['vegano']?.toLowerCase() == 'sí' ||
        _responses['vegano']?.toLowerCase() == 's');
    int ropa = int.tryParse(_responses['ropa'] ?? '0') ?? 0;
    int electronicos = int.tryParse(_responses['electronicos'] ?? '0') ?? 0;
    int vuelos = int.tryParse(_responses['viajes_avion'] ?? '0') ?? 0;

    // Cálculos (aproximaciones)
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

    // Ajuste si la persona sigue una dieta vegana (reducción del 20%)
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
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_quizStarted) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Huella de Carbono"),
          backgroundColor: const Color(0xff368983),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: _startQuiz,
            child: const Text("Comenzar cuestionario"),
          ),
        ),
      );
    }

    if (_quizFinished) {
      return ResultWidget(
        huellaTotal: _huellaTotal,
        onRestart: _restartQuiz,
      );
    }

    return QuestionWidget(
      question: _questions[_currentQuestionIndex],
      onSubmit: _submitAnswer,
    );
  }
}
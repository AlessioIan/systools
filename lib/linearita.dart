import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class LinearitaPage extends StatefulWidget {
  const LinearitaPage({super.key});

  @override
  State<LinearitaPage> createState() => _LinearitaPageState();
}

class _LinearitaPageState extends State<LinearitaPage> {
  final List<TextEditingController> _odControllers = [];
  final List<TextEditingController> _concControllers = [];
  double? _rSquared;
  double? _slope;
  double? _intercept;
  List<Point<double>> _dataPoints = [];
  List<Point<double>> _regressionPoints = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (int i = 0; i < 5; i++) {
      _odControllers.add(TextEditingController());
      _concControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in _odControllers) {
      controller.dispose();
    }
    for (var controller in _concControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _resetFields() {
    setState(() {
      for (var controller in _odControllers) {
        controller.clear();
      }
      for (var controller in _concControllers) {
        controller.clear();
      }
      _rSquared = null;
      _slope = null;
      _intercept = null;
      _dataPoints = [];
      _regressionPoints = [];
    });
  }

  void _calculateLinearity() {
    List<double> odValues = [];
    List<double> concValues = [];
    _dataPoints = [];

    for (int i = 0; i < _odControllers.length; i++) {
      if (_odControllers[i].text.isNotEmpty && _concControllers[i].text.isNotEmpty) {
        try {
          double od = double.parse(_odControllers[i].text.replaceAll(',', '.'));
          double conc = double.parse(_concControllers[i].text.replaceAll(',', '.'));
          odValues.add(od);
          concValues.add(conc);
          _dataPoints.add(Point(od, conc));
        } catch (e) {
          // Ignora valori non validi
        }
      }
    }

    if (odValues.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserisci almeno due coppie di valori validi')),
      );
      return;
    }

    // Calcola le medie
    double meanX = odValues.reduce((a, b) => a + b) / odValues.length;
    double meanY = concValues.reduce((a, b) => a + b) / concValues.length;

    // Calcola i coefficienti della regressione lineare
    double numerator = 0;
    double denominator = 0;

    for (int i = 0; i < odValues.length; i++) {
      numerator += (odValues[i] - meanX) * (concValues[i] - meanY);
      denominator += pow(odValues[i] - meanX, 2);
    }

    setState(() {
      _slope = numerator / denominator;
      _intercept = meanY - (_slope ?? 0) * meanX;

      // Calcola R²
      double ssRes = 0;
      double ssTot = 0;
      
      for (int i = 0; i < odValues.length; i++) {
        double prediction = (_slope ?? 0) * odValues[i] + (_intercept ?? 0);
        ssRes += pow(concValues[i] - prediction, 2);
        ssTot += pow(concValues[i] - meanY, 2);
      }
      
      _rSquared = 1 - (ssRes / ssTot);

      // Genera punti per la linea di regressione
      double minX = odValues.reduce(min);
      double maxX = odValues.reduce(max);
      _regressionPoints = [
        Point(minX, _slope! * minX + _intercept!),
        Point(maxX, _slope! * maxX + _intercept!)
      ];
    });
  }

  void _addNewRow() {
    setState(() {
      _odControllers.add(TextEditingController());
      _concControllers.add(TextEditingController());
    });
  }

  Widget _buildGraph() {
    if (_dataPoints.isEmpty) return const SizedBox.shrink();
    
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: CustomPaint(
        size: const Size(double.infinity, double.infinity),
        painter: ScatterPlotPainter(
          points: _dataPoints,
          regressionLine: _regressionPoints,
        ),
      ),
    );
  }

  String _getEquation() {
    if (_slope == null || _intercept == null) return '';
    String interceptSign = _intercept! >= 0 ? '+' : '';
    return 'y = ${_slope!.toStringAsFixed(4)}x $interceptSign${_intercept!.toStringAsFixed(4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifica Linearità'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Inserisci i valori di OD e Concentrazione',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _odControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _odControllers[index],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: 'OD ${index + 1}',
                            border: const OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _concControllers[index],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: 'Conc. ${index + 1}',
                            border: const OutlineInputBorder(),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addNewRow,
                  child: const Text('Aggiungi Riga'),
                ),
                ElevatedButton(
                  onPressed: _calculateLinearity,
                  child: const Text('Calcola Linearità'),
                ),
                ElevatedButton(
                  onPressed: _resetFields,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
            if (_rSquared != null && _slope != null && _intercept != null) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Equazione della retta: ${_getEquation()}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Coefficiente di determinazione (R²): ${_rSquared!.toStringAsFixed(4)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pendenza: ${_slope!.toStringAsFixed(4)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Intercetta: ${_intercept!.toStringAsFixed(4)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: _buildGraph(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ScatterPlotPainter extends CustomPainter {
  final List<Point<double>> points;
  final List<Point<double>> regressionLine;
  
  ScatterPlotPainter({required this.points, required this.regressionLine});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    // Trova i valori min e max per la scala
    double minX = points.map((p) => p.x).reduce(min);
    double maxX = points.map((p) => p.x).reduce(max);
    double minY = points.map((p) => p.y).reduce(min);
    double maxY = points.map((p) => p.y).reduce(max);

    // Aggiungi un margine del 10%
    double xMargin = (maxX - minX) * 0.1;
    double yMargin = (maxY - minY) * 0.1;
    minX -= xMargin;
    maxX += xMargin;
    minY -= yMargin;
    maxY += yMargin;

    // Funzioni per convertire le coordinate
    double scaleX(double x) => (x - minX) / (maxX - minX) * size.width;
    double scaleY(double y) => size.height - (y - minY) / (maxY - minY) * size.height;

    // Disegna gli assi
    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      axisPaint,
    );
    canvas.drawLine(
      const Offset(0, 0),
      Offset(0, size.height),
      axisPaint,
    );

    // Disegna i punti
    paint.color = Colors.blue;
    for (var point in points) {
      canvas.drawCircle(
        Offset(scaleX(point.x), scaleY(point.y)),
        4,
        paint,
      );
    }

    // Disegna la linea di regressione
    if (regressionLine.length == 2) {
      paint.color = Colors.red;
      paint.style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(scaleX(regressionLine[0].x), scaleY(regressionLine[0].y)),
        Offset(scaleX(regressionLine[1].x), scaleY(regressionLine[1].y)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
import 'package:flutter/material.dart';
import 'dart:math';

class AccuratezzaPage extends StatefulWidget {
  @override
  _AccuratezzaPageState createState() => _AccuratezzaPageState();
}

class _AccuratezzaPageState extends State<AccuratezzaPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _targetController = TextEditingController();
  TextEditingController _valueController = TextEditingController();
  List<double> _experimentalValues = [];
  List<double> _accuracyValues = [];
  double _mean = 0;
  double _standardDeviation = 0;
  double _percentStandardDeviation = 0;
  double _mdl = 0;

  void _calculateStatistics() {
    if (_experimentalValues.isEmpty) return;

    // Calcola la media
    _mean = _experimentalValues.reduce((a, b) => a + b) / _experimentalValues.length;

    // Calcola la deviazione standard
    double sumSquaredDiff = _experimentalValues.fold(0, (sum, value) {
      return sum + pow(value - _mean, 2);
    });
    _standardDeviation = sqrt(sumSquaredDiff / (_experimentalValues.length - 1));

    // Calcola la deviazione standard percentuale
    _percentStandardDeviation = (_standardDeviation / _mean) * 100;

    // Calcola MDL
    _mdl = _standardDeviation * pi;

    setState(() {});
  }

  void _addValue() {
    if (_formKey.currentState!.validate()) {
      double target = double.parse(_targetController.text);
      double value = double.parse(_valueController.text);
      
      // Calcola l'accuratezza
      double accuracy = 100 - (((target - value).abs() / target) * 100);
      
      setState(() {
        _experimentalValues.add(value);
        _accuracyValues.add(accuracy);
        _calculateStatistics();
      });

      _valueController.clear();
    }
  }

  void _resetFields() {
    setState(() {
      _targetController.clear();
      _valueController.clear();
      _experimentalValues.clear();
      _accuracyValues.clear();
      _mean = 0;
      _standardDeviation = 0;
      _percentStandardDeviation = 0;
      _mdl = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accuratezza'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _targetController,
                decoration: InputDecoration(labelText: 'Valore Target'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserire un valore';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Inserire un numero valido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _valueController,
                decoration: InputDecoration(labelText: 'Valore Sperimentale'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserire un valore';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Inserire un numero valido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _addValue,
                    child: Text('Aggiungi Valore'),
                  ),
                  ElevatedButton(
                    onPressed: _resetFields,
                    child: Text('Reset'),
                  ),
                ],
              ),
              SizedBox(height: 24),
              if (_experimentalValues.isNotEmpty) ...[
                Text('Valori Sperimentali e Accuratezza:',
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _experimentalValues.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Valore: ${_experimentalValues[index].toStringAsFixed(2)}'),
                      subtitle: Text('Accuratezza: ${_accuracyValues[index].toStringAsFixed(2)}%'),
                    );
                  },
                ),
                SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Statistiche:', style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(height: 8),
                        Text('Media: ${_mean.toStringAsFixed(2)}'),
                        Text('Deviazione Standard: ${_standardDeviation.toStringAsFixed(2)}'),
                        Text('Deviazione Standard %: ${_percentStandardDeviation.toStringAsFixed(2)}%'),
                        Text('MDL: ${_mdl.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _targetController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}
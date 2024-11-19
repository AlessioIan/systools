import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalcoloRisultatiPage extends StatefulWidget {
  const CalcoloRisultatiPage({Key? key}) : super(key: key);

  @override
  _CalcoloRisultatiPageState createState() => _CalcoloRisultatiPageState();
}

class _CalcoloRisultatiPageState extends State<CalcoloRisultatiPage> {
  final TextEditingController _blankODend = TextEditingController();
  final TextEditingController _calibrantODend = TextEditingController();
  final TextEditingController _calibrantValue = TextEditingController();
  final TextEditingController _sampleODend = TextEditingController();
  final TextEditingController _targetConcentration = TextEditingController();
  final TextEditingController _targetODend = TextEditingController();

  double _concentration = 0;
  double _requiredCalibrantODend = 0;

  @override
  void initState() {
    super.initState();
    _addListeners();
  }

  void _addListeners() {
  _blankODend.addListener(_calculateValues);
  _calibrantODend.addListener(_calculateValues);
  _calibrantValue.addListener(_calculateValues);
  _sampleODend.addListener(_calculateValues);
  _targetConcentration.addListener(_calculateValues);
  _targetODend.addListener(_calculateValues);

  }

  void _calculateValues() {
    setState(() {
      final blank = _parseDouble(_blankODend.text);
      final calibrant = _parseDouble(_calibrantODend.text);
      final calibrantVal = _parseDouble(_calibrantValue.text);
      final sample = _parseDouble(_sampleODend.text);
      final targetConc = _parseDouble(_targetConcentration.text);
      final targetOD = _parseDouble(_targetODend.text);

      _concentration = calibrant > blank 
          ? (calibrantVal / (calibrant - blank)) * (sample - blank)
          : 0;

      _requiredCalibrantODend = targetConc > 0 
          ? (calibrantVal / targetConc) * (targetOD - blank) + blank
          : 0;
    });
  }

  double _parseDouble(String value) {
    return double.tryParse(value) ?? 0;
  }

  void _resetFields() {
    setState(() {
      _blankODend.clear();
      _calibrantODend.clear();
      _calibrantValue.clear();
      _sampleODend.clear();
      _targetConcentration.clear();
      _targetODend.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calcolo Risultati')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('CALIBRATION LINE', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInputFields(),
            const SizedBox(height: 24),
            _buildResults(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _resetFields,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        _buildInputField(_blankODend, 'BLANK ODend'),
        _buildInputField(_calibrantODend, 'CALIBRANT ODend'),
        _buildInputField(_calibrantValue, 'CALIBRANT Value'),
        _buildInputField(_sampleODend, 'Sample ODend'),
        _buildInputField(_targetConcentration, 'Target Concentration'),
        _buildInputField(_targetODend, 'Target ODend'),
      ],
    );
  }

  Widget _buildInputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.yellow[50],
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Concentration: ${_concentration.toStringAsFixed(3)}',
          style: const TextStyle(fontSize: 16)),
        Text('Required CALIBRANT ODend: ${_requiredCalibrantODend.toStringAsFixed(3)}',
          style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  @override
  void dispose() {
    _blankODend.dispose();
    _calibrantODend.dispose();
    _calibrantValue.dispose();
    _sampleODend.dispose();
    _targetConcentration.dispose();
    _targetODend.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DiluizioniPage extends StatefulWidget {
  const DiluizioniPage({Key? key}) : super(key: key);

  @override
  _DiluizioniPageState createState() => _DiluizioniPageState();
}

class _DiluizioniPageState extends State<DiluizioniPage> with SingleTickerProviderStateMixin {
  // Controller per i tab
  late TabController _tabController;
  
  // Controllers per il calcolatore
  final TextEditingController _concentrazioneCalibrante = TextEditingController();
  final TextEditingController _secCampione = TextEditingController();
  final TextEditingController _secAcqua = TextEditingController();
  final TextEditingController _secButtati = TextEditingController();
  final TextEditingController _secAcquaInseriti = TextEditingController();
  
  // Controllers per il simulatore
  final TextEditingController _odCalibrante = TextEditingController();
  final TextEditingController _targetConc1 = TextEditingController();
  final TextEditingController _targetVol1 = TextEditingController();
  final TextEditingController _targetConc2 = TextEditingController();
  final TextEditingController _targetVol2 = TextEditingController();

  // Risultati calcolatore
  double _secTotali1 = 0;
  double _concentrazione1 = 0;
  double _secTotali2 = 0;
  double _concentrazione2 = 0;

  // Risultati simulatore
  double _simSecCampione = 0;
  double _simSecAcqua1 = 0;
  double _simSecButtare = 0;
  double _simSecAcqua2 = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Aggiungi listeners per i calcoli automatici
    _concentrazioneCalibrante.addListener(_calcolatoreUpdate);
    _secCampione.addListener(_calcolatoreUpdate);
    _secAcqua.addListener(_calcolatoreUpdate);
    _secButtati.addListener(_calcolatoreUpdate);
    _secAcquaInseriti.addListener(_calcolatoreUpdate);

    _odCalibrante.addListener(_simulatoreUpdate);
    _targetConc1.addListener(_simulatoreUpdate);
    _targetVol1.addListener(_simulatoreUpdate);
    _targetConc2.addListener(_simulatoreUpdate);
    _targetVol2.addListener(_simulatoreUpdate);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _concentrazioneCalibrante.dispose();
    _secCampione.dispose();
    _secAcqua.dispose();
    _secButtati.dispose();
    _secAcquaInseriti.dispose();
    _odCalibrante.dispose();
    _targetConc1.dispose();
    _targetVol1.dispose();
    _targetConc2.dispose();
    _targetVol2.dispose();
    super.dispose();
  }

  double _parseInput(String value) {
    if (value.isEmpty) return 0;
    try {
      final parsed = double.parse(value);
      if (parsed.isNegative) return 0;
      if (parsed > 9999) return 9999;
      return parsed;
    } catch (e) {
      return 0;
    }
  }

  void _calcolatoreUpdate() {
    setState(() {
      final concentrazioneCalibrante = _parseInput(_concentrazioneCalibrante.text);
      final secCampione = _parseInput(_secCampione.text);
      final secAcqua = _parseInput(_secAcqua.text);
      final secButtati = _parseInput(_secButtati.text);
      final secAcquaInseriti = _parseInput(_secAcquaInseriti.text);
      
      // Prima diluizione
      _secTotali1 = secCampione + secAcqua;
      _concentrazione1 = _secTotali1 > 0 
          ? (secCampione / _secTotali1) * concentrazioneCalibrante 
          : 0;

      // Seconda diluizione
      final volumeRimanente = _secTotali1 - secButtati;
      _secTotali2 = volumeRimanente + secAcquaInseriti;
      _concentrazione2 = _secTotali2 > 0 
          ? (volumeRimanente / _secTotali2) * _concentrazione1 
          : 0;
    });
  }

  void _simulatoreUpdate() {
    setState(() {
      final od = _parseInput(_odCalibrante.text);
      final targetConc1 = _parseInput(_targetConc1.text);
      final targetVol1 = _parseInput(_targetVol1.text);
      final targetConc2 = _parseInput(_targetConc2.text);
      final targetVol2 = _parseInput(_targetVol2.text);

      // Prima diluizione
      _simSecCampione = (targetConc1 / od) * targetVol1;
      _simSecAcqua1 = targetVol1 - _simSecCampione;

      // Seconda diluizione
      _simSecAcqua2 = targetVol2 - ((targetVol2 * targetConc2) / targetConc1);
      _simSecButtare = _simSecAcqua2 + (targetVol1 - targetVol2);  // Formula corretta
    });
  }
  void _resetCalcolatore() {
    setState(() {
      _concentrazioneCalibrante.clear();
      _secCampione.clear();
      _secAcqua.clear();
      _secButtati.clear();
      _secAcquaInseriti.clear();
    });
  }

  void _resetSimulatore() {
    setState(() {
      _odCalibrante.clear();
      _targetConc1.clear();
      _targetVol1.clear();
      _targetConc2.clear();
      _targetVol2.clear();
    });
  }

  InputDecoration _getInputDecoration(String label, bool isEditable) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: isEditable ? Colors.green[50] : Colors.blue[50],
      labelStyle: TextStyle(
        color: isEditable ? Colors.green[900] : Colors.blue[900],
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: isEditable ? Colors.green[300]! : Colors.blue[300]!,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isEditable ? Colors.green[300]! : Colors.blue[300]!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isEditable ? Colors.green[500]! : Colors.blue[500]!,
        ),
      ),
    );
  }

  List<TextInputFormatter> _getInputFormatters() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diluizioni'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'CALCOLATORE'),
            Tab(text: 'SIMULATORE'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCalcolatore(),
          _buildSimulatore(),
        ],
      ),
    );
  }

  Widget _buildCalcolatore() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _concentrazioneCalibrante,
            decoration: _getInputDecoration('Concentrazione calibrante (U.M.)', true),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: _getInputFormatters(),
          ),
          const SizedBox(height: 24),

          const Text('Prima diluizione', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 16),
          _buildInputGrid([
            TextFieldData(_secCampione, 'Sec. di campione', true),
            TextFieldData(_secAcqua, 'Sec. di acqua', true),
            TextFieldData(null, 'Sec. totali 1° dil', false, _secTotali1.toStringAsFixed(3)),
            TextFieldData(null, 'Concentrazione in cella 1° dil (U.M.)', false, 
              _concentrazione1.toStringAsFixed(3)),
          ]),
          const SizedBox(height: 24),

          const Text('Seconda diluizione', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 16),
          _buildInputGrid([
            TextFieldData(_secButtati, 'Sec. buttati', true),
            TextFieldData(_secAcquaInseriti, 'Sec. di acqua inseriti', true),
            TextFieldData(null, 'Sec. totali 2° dil', false, _secTotali2.toStringAsFixed(3)),
            TextFieldData(null, 'Concentrazione in cella 2° dil (U.M.)', false, 
              _concentrazione2.toStringAsFixed(3)),
          ]),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _resetCalcolatore,
            child: const Text('Reset Calcolatore'),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatore() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _odCalibrante,
            decoration: _getInputDecoration('O.D. Calibrante', true),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: _getInputFormatters(),
          ),
          const SizedBox(height: 24),

          const Text('Prima diluizione', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 16),
          _buildInputGrid([
            TextFieldData(_targetConc1, 'Nella prima dil. voglio una concentrazione di (U.M.)', true),
            TextFieldData(_targetVol1, 'Voglio un volume totale 1° dil di (sec)', true),
            TextFieldData(null, 'Mi servono questi secondi di campione', false, 
              _simSecCampione.toStringAsFixed(3)),
            TextFieldData(null, 'Mi servono questi secondi di acqua', false, 
              _simSecAcqua1.toStringAsFixed(3)),
          ]),
          const SizedBox(height: 24),

          const Text('Seconda diluizione', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 16),
          _buildInputGrid([
            TextFieldData(_targetConc2, 'Nella seconda dil. voglio una concentrazione di (U.M.)', true),
            TextFieldData(_targetVol2, 'Voglio un volume totale 2° dil di (sec)', true),
            TextFieldData(null, 'Devo buttare questi secondi di 1° dil', false, 
              _simSecButtare.toStringAsFixed(3)),
            TextFieldData(null, 'Mi servono questi secondi di acqua', false, 
              _simSecAcqua2.toStringAsFixed(3)),
          ]),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _resetSimulatore,
            child: const Text('Reset Simulatore'),
          ),
        ],
      ),
    );
  }

  Widget _buildInputGrid(List<TextFieldData> fields) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: fields.length,
      itemBuilder: (context, index) {
        final field = fields[index];
        return field.controller != null
            ? TextField(
                controller: field.controller,
                decoration: _getInputDecoration(field.label, field.isEditable),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: _getInputFormatters(),
              )
            : TextField(
                decoration: _getInputDecoration(field.label, field.isEditable),
                enabled: false,
                controller: TextEditingController(text: field.value),
              );
      },
    );
  }
}

class TextFieldData {
  final TextEditingController? controller;
  final String label;
  final bool isEditable;
  final String? value;

  TextFieldData(this.controller, this.label, this.isEditable, [this.value]);
}
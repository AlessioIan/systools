import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class RisultatiTS2 extends StatefulWidget {
  const RisultatiTS2({super.key});

  @override
  State<RisultatiTS2> createState() => _RisultatiTS2State();
}

class _RisultatiTS2State extends State<RisultatiTS2> {
  PlatformFile? selectedFile;
  String? errorMessage;
  List<Map<String, dynamic>> parsedData = [];
  bool isDataLoaded = false;

  void _showMessage(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void _processFileData(List<int> bytes) {
    try {
      String content = utf8.decode(bytes);
      List<String> lines = content.split('\n');
      List<Map<String, dynamic>> processedData = [];

      // Salta la prima riga come richiesto
      for (var i = 1; i < lines.length; i++) {
        if (lines[i].trim().isNotEmpty) {
          try {
            List<String> parts = lines[i].split(','); // Assumo che il separatore sia una virgola
            if (parts.length >= 10) { // Verifica che ci siano tutti i campi necessari
              Map<String, dynamic> record = {
                'numero_rigo': parts[0].trim(),
                'data': parts[1].trim(),
                'metodo': parts[2].trim(),
                'ciclo': parts[3].trim(),
                'risultato': parts[4].trim(),
                'unita_misura': parts[5].trim(),
                'flag': parts[6].trim(),
                'ods': parts[7].trim(),
                'ode': parts[8].trim(),
                'note': parts[9].trim(),
              };
              processedData.add(record);
            }
          } catch (e) {
            print('Errore nel processare la riga $i: $e');
          }
        }
      }

      setState(() {
        parsedData = processedData;
        isDataLoaded = true;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Errore nell\'elaborazione del file: $e';
        isDataLoaded = false;
      });
    }
  }

  Future<void> _pickFile() async {
    try {
      setState(() {
        errorMessage = null;
        isDataLoaded = false;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'csv'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null) {
        setState(() {
          selectedFile = result.files.first;
        });

        if (selectedFile?.bytes != null) {
          _processFileData(selectedFile!.bytes!);
          _showMessage('File elaborato con successo!', isError: false);
        } else {
          setState(() {
            errorMessage = 'Impossibile leggere i dati del file';
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Errore durante la selezione del file: $e';
      });
      _showMessage('Errore: $e');
    }
  }

  void _exportToCsv() {
    try {
      // Crea l'intestazione del CSV
      String csvContent = 'Numero Rigo;Data;Metodo;Ciclo;Risultato;Unità di Misura;Flag;ODS;ODE;Note\n';

      // Aggiunge i dati
      for (var row in parsedData) {
        csvContent += '${row['numero_rigo']};'
            '${row['data']};'
            '${row['metodo']};'
            '${row['ciclo']};'
            '${row['risultato']};'
            '${row['unita_misura']};'
            '${row['flag']};'
            '${row['ods']};'
            '${row['ode']};'
            '${row['note']}\n';
      }

      // Aggiunge BOM per Excel e codifica il contenuto
      final bytes = utf8.encode('\uFEFF$csvContent');
      
      // Crea e scarica il file
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "risultati_ts2.csv")
        ..click();
      html.Url.revokeObjectUrl(url);

      _showMessage('File CSV scaricato con successo!', isError: false);
    } catch (e) {
      _showMessage('Errore durante l\'esportazione del CSV: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risultati TS 2.x.x'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Riga dei pulsanti
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                  onPressed: _pickFile,
                  icon: const Icon(Icons.file_upload),
                  label: const Text('Carica file'),
                ),
                if (isDataLoaded && parsedData.isNotEmpty) ...[
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                    onPressed: _exportToCsv,
                    icon: const Icon(Icons.download),
                    label: const Text('Scarica CSV'),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            
            // Informazioni sul file
            if (selectedFile != null) ...[
              Text(
                'File selezionato: ${selectedFile!.name}',
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
              Text(
                'Dimensione: ${(selectedFile!.size / 1024).toStringAsFixed(2)} KB',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),
            ],

            // Messaggio di errore
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),

            // Tabella dei dati
            if (isDataLoaded && parsedData.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,  // Spazio ridotto tra colonne
                      horizontalMargin: 10, // Margini orizzontali ridotti
                      headingRowHeight: 40, // Altezza ridotta dell'header
                      dataRowHeight: 40,    // Altezza ridotta delle righe
                      columns: const [
                        DataColumn(label: Text('N.Rigo', style: TextStyle(fontSize: 12))),
                        DataColumn(label: Text('Data', style: TextStyle(fontSize: 12))),
                        DataColumn(label: Text('Met.', style: TextStyle(fontSize: 12))),
                        DataColumn(label: Text('Ciclo', style: TextStyle(fontSize: 12))),
                        DataColumn(label: Text('Ris.', style: TextStyle(fontSize: 12))),
                        DataColumn(label: Text('U.M.', style: TextStyle(fontSize: 12))),
                        DataColumn(label: Text('Flag', style: TextStyle(fontSize: 12))),
                        DataColumn(label: Text('ODS', style: TextStyle(fontSize: 12))),
                        DataColumn(label: Text('ODE', style: TextStyle(fontSize: 12))),
                        DataColumn(label: Text('Note', style: TextStyle(fontSize: 12))),
                      ],
                      rows: parsedData.map((row) => DataRow(
                        cells: [
                          DataCell(Text(row['numero_rigo'], style: const TextStyle(fontSize: 12))),
                          DataCell(Text(row['data'], style: const TextStyle(fontSize: 12))),
                          DataCell(Text(row['metodo'], style: const TextStyle(fontSize: 12))),
                          DataCell(Text(row['ciclo'], style: const TextStyle(fontSize: 12))),
                          DataCell(Text(row['risultato'], style: const TextStyle(fontSize: 12))),
                          DataCell(Text(row['unita_misura'], style: const TextStyle(fontSize: 12))),
                          DataCell(Text(row['flag'], style: const TextStyle(fontSize: 12))),
                          DataCell(Text(row['ods'], style: const TextStyle(fontSize: 12))),
                          DataCell(Text(row['ode'], style: const TextStyle(fontSize: 12))),
                          DataCell(Text(row['note'], style: const TextStyle(fontSize: 12))),
                        ],
                      )).toList(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
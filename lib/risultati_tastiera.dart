import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class RisultatiTastiera extends StatefulWidget {
  const RisultatiTastiera({super.key});

  @override
  State<RisultatiTastiera> createState() => _RisultatiTastieraState();
}

class _RisultatiTastieraState extends State<RisultatiTastiera> {
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

  String _getAnalysisType(int code) {
    const types = {
      1: "Analisi",
      2: "Calibrazione",
      3: "Calibrazione OVER RANGE",
      4: "Diluito",
      5: "Bianco",
      6: "Grab Sample",
      7: "Sample OVER RANGE",
      8: "Blank OVER RANGE",
      10: "Analisi ISE",
      11: "Calibrazione ISE"
    };
    return types[code] ?? "Sconosciuto";
  }

  void _processFileData(List<int> bytes) {
    try {
      String content = utf8.decode(bytes);
      List<String> lines = content.split('\n');
      List<Map<String, dynamic>> processedData = [];

      for (var i = 0; i < lines.length; i += 8) {
        if (i + 7 < lines.length && lines[i + 1].trim() != "Empty") {
          try {
            Map<String, dynamic> record = {
              'datetime': lines[i].trim(),
              'method': lines[i + 1].trim(),
              'type': int.tryParse(lines[i + 2].trim()) ?? 0,
              'value1': double.tryParse(lines[i + 3].trim()) ?? 0.0,
              'value2': double.tryParse(lines[i + 4].trim()) ?? 0.0,
              'value3': double.tryParse(lines[i + 5].trim()) ?? 0.0,
              'value4': double.tryParse(lines[i + 6].trim()) ?? 0.0,
              'number': int.tryParse(lines[i + 7].trim()) ?? 0,
            };

            if (record['method'] != "Empty") {
              processedData.add(record);
            }
          } catch (e) {
            print('Errore nel processare le righe $i-${i + 7}: $e');
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
        allowedExtensions: ['dat', 'DAT'],
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
      String csvContent = 'Data/Ora;Metodo;Tipo Analisi;Risultato;#;ODS;ODE;#\n';

      // Aggiunge i dati
      for (var row in parsedData) {
        csvContent += '${row['datetime']};'
            '${row['method']};'
            '${_getAnalysisType(row['type'])};'
            '${row['value1'].toStringAsFixed(3)};'
            '${row['value2'].toStringAsFixed(3)};'
            '${row['value3'].toStringAsFixed(3)};'
            '${row['value4'].toStringAsFixed(3)};'
            '${row['number']}\n';
      }

      // Aggiunge BOM per Excel e codifica il contenuto
      final bytes = utf8.encode('\uFEFF$csvContent');
      
      // Crea e scarica il file
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "analisi_dati.csv")
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
        title: const Text('Risultati Tastiera'),
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
                  label: const Text('Carica file DATI.DAT'),
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
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Data/Ora')),
                        DataColumn(label: Text('Metodo')),
                        DataColumn(label: Text('Tipo')),
                        DataColumn(label: Text('Risultato')),
                        DataColumn(label: Text('#')),
                        DataColumn(label: Text('ODS')),
                        DataColumn(label: Text('ODE')),
                        DataColumn(label: Text('#')),
                      ],
                      rows: parsedData.map((row) => DataRow(
                        cells: [
                          DataCell(Text(row['datetime'])),
                          DataCell(Text(row['method'])),
                          DataCell(Text(_getAnalysisType(row['type']))),
                          DataCell(Text(row['value1'].toStringAsFixed(3))),
                          DataCell(Text(row['value2'].toStringAsFixed(3))),
                          DataCell(Text(row['value3'].toStringAsFixed(3))),
                          DataCell(Text(row['value4'].toStringAsFixed(3))),
                          DataCell(Text(row['number'].toString())),
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
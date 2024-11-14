import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:html' as html;
//ti permette di modificare un ciclo
class CycleRow {
  final int index;
  List<String> values;
  final List<TextEditingController> controllers;
  
  CycleRow({
    required this.index,
    required this.values,
  }) : controllers = values.map((value) => TextEditingController(text: value)).toList();

  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
  }

  void updateIndex(int newIndex) {
    values = values;
  }
}

class ModificaCicloPage extends StatefulWidget {
  const ModificaCicloPage({Key? key}) : super(key: key);

  @override
  State<ModificaCicloPage> createState() => _ModificaCicloPageState();
}

class _ModificaCicloPageState extends State<ModificaCicloPage> {
  final List<CycleRow> _rows = [];
  String? _status;
  bool _isProcessing = false;
  String _originalFileName = '';

  @override
  void dispose() {
    for (var row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  bool _isValidNumber(String value) {
    try {
      if (value.isEmpty) return true;
      final number = int.parse(value);
      return number >= 0 && number <= 999;
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadFile() async {
    try {
      setState(() {
        _isProcessing = true;
        _status = 'Seleziona il file...';
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        _originalFileName = file.name;
        
        if (file.bytes != null) {
          String content = utf8.decode(file.bytes!);
          List<String> lines = content.split('\n')
              .where((line) => line.trim().isNotEmpty)
              .toList();

          // Dispose existing controllers
          for (var row in _rows) {
            row.dispose();
          }
          _rows.clear();
          
          // Raggruppa le linee in gruppi di 3
          for (var i = 0; i < lines.length; i += 3) {
            List<String> rowValues = [];
            for (var j = 0; j < 3; j++) {
              if (i + j < lines.length) {
                rowValues.add(lines[i + j].trim());
              } else {
                rowValues.add('0');
              }
            }
            
            _rows.add(CycleRow(
              index: (_rows.length + 1),
              values: rowValues,
            ));
          }

          setState(() {
            _status = 'File caricato con successo';
          });
        }
      } else {
        setState(() {
          _status = 'Nessun file selezionato';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Errore durante il caricamento: $e';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _insertRow(int index) {
    setState(() {
      if (_rows.length >= 200) {
        // Rimuovi l'ultima riga
        _rows.last.dispose(); // Pulizia dei controller
        _rows.removeLast();
      }
      // Inserisci la nuova riga
      _rows.insert(index, CycleRow(
        index: index + 1,
        values: ['0', '0', '0'],
      ));
      _updateIndices();
    });
  }

  void _removeRow(int index) {
    setState(() {
      _rows[index].dispose();
      _rows.removeAt(index);
      _updateIndices();
    });
  }

  void _updateIndices() {
    for (var i = 0; i < _rows.length; i++) {
      _rows[i] = CycleRow(
        index: i + 1,
        values: _rows[i].values,
      );
    }
  }

  Future<void> _downloadFile() async {
    try {
      List<String> outputLines = [];
      for (var row in _rows) {
        for (var controller in row.controllers) {
          outputLines.add(controller.text.isEmpty ? '0' : controller.text);
        }
      }
      
      while (outputLines.length < 600) {
        outputLines.add('0');
      }

      final content = outputLines.join('\n');
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      final anchor = html.AnchorElement()
        ..href = url
        ..download = _originalFileName.isNotEmpty ? _originalFileName.replaceAll('.txt', '') : 'ciclo_modificato'
        ..style.display = 'none';

      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      
      html.Url.revokeObjectUrl(url);

      setState(() {
        _status = 'File scaricato con successo';
      });
    } catch (e) {
      setState(() {
        _status = 'Errore durante il download: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica Ciclo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_status != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isProcessing)
                      const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    Flexible(
                      child: Text(
                        _status!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _status!.contains('Errore') ? Colors.red : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _loadFile,
                  icon: const Icon(Icons.file_upload),
                  label: const Text('Carica File'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _rows.isEmpty ? null : _downloadFile,
                  icon: const Icon(Icons.file_download),
                  label: const Text('Scarica File'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  columnWidths: const {
                    0: FixedColumnWidth(50),
                    1: FixedColumnWidth(100),
                    2: FixedColumnWidth(100),
                    3: FixedColumnWidth(100),
                    4: FixedColumnWidth(100),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      children: const [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '#',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'CODE',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'TIME',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'TIC',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Azioni',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ..._rows.asMap().entries.map((entry) {
                      final index = entry.key;
                      final row = entry.value;
                      return TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                row.index.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          ...List.generate(3, (valueIndex) => TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                width: 80,
                                child: TextFormField(
                                  controller: row.controllers[valueIndex],
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  onChanged: (value) {
                                    if (value.isEmpty || _isValidNumber(value)) {
                                      row.values[valueIndex] = value.isEmpty ? '0' : value;
                                    }
                                  },
                                ),
                              ),
                            ),
                          )),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, 
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () => _insertRow(index),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.delete, 
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () => _removeRow(index),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
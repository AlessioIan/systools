import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:html' as html;
//va a esportare in excel i cicli
class ProcessedFile {
  final String fileName;
  final String content;
  bool isProcessed;

  ProcessedFile({
    required this.fileName,
    required this.content,
    this.isProcessed = false,
  });
}

class EsportaExcelPage extends StatefulWidget {
  const EsportaExcelPage({Key? key}) : super(key: key);

  @override
  State<EsportaExcelPage> createState() => _EsportaExcelPageState();
}

class _EsportaExcelPageState extends State<EsportaExcelPage> {
  bool _isProcessing = false;
  String? _status;
  final List<ProcessedFile> _processedFiles = [];

  Future<void> _processFiles() async {
    try {
      setState(() {
        _isProcessing = true;
        _status = 'Seleziona i file...';
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _status = 'Elaborazione in corso...';
        });

        _processedFiles.clear();

        for (final file in result.files) {
          if (file.bytes != null) {
            String content = utf8.decode(file.bytes!);
            List<String> lines = content.split('\n');
            lines = lines.where((line) => line.trim().isNotEmpty).toList();
            List<String> csvLines = [];
            
            for (var i = 0; i < lines.length; i += 3) {
              if (i + 2 < lines.length) {
                String csvLine = '${lines[i].trim()};${lines[i + 1].trim()};${lines[i + 2].trim()}';
                csvLines.add(csvLine);
              }
            }

            _processedFiles.add(ProcessedFile(
              fileName: file.name.split('.').first,
              content: csvLines.join('\n'),
            ));
          }
        }

        setState(() {
          _status = '${_processedFiles.length} file pronti per il download';
        });
      } else {
        setState(() {
          _status = 'Nessun file selezionato';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Errore: $e';
        _processedFiles.clear();
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _downloadFile(ProcessedFile processedFile) async {
    try {
      // Crea il blob per il download
      final bytes = utf8.encode(processedFile.content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      
      // Crea l'elemento anchor per il download
      final anchor = html.AnchorElement()
        ..href = url
        ..download = '${processedFile.fileName}.csv'
        ..style.display = 'none';

      // Aggiungi, clicca e rimuovi l'anchor
      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      
      // Pulisci l'URL
      html.Url.revokeObjectUrl(url);

      setState(() {
        processedFile.isProcessed = true;
        _status = 'File ${processedFile.fileName}.csv scaricato con successo!';
      });
    } catch (e) {
      setState(() {
        _status = 'Errore durante il salvataggio di ${processedFile.fileName}: $e';
      });
    }
  }

  Future<void> _downloadAllFiles() async {
    try {
      setState(() {
        _status = 'Avvio download dei file...';
      });

      for (var i = 0; i < _processedFiles.length; i++) {
        var processedFile = _processedFiles[i];
        
        try {
          // Crea il blob per il download
          final bytes = utf8.encode(processedFile.content);
          final blob = html.Blob([bytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          
          // Crea l'elemento anchor per il download
          final anchor = html.AnchorElement()
            ..href = url
            ..download = '${processedFile.fileName}.csv'
            ..style.display = 'none';

          // Aggiungi, clicca e rimuovi l'anchor
          html.document.body?.children.add(anchor);
          anchor.click();
          html.document.body?.children.remove(anchor);
          
          // Pulisci l'URL
          html.Url.revokeObjectUrl(url);

          // Aggiorna lo stato
          setState(() {
            processedFile.isProcessed = true;
            _status = 'Scaricato ${i + 1} di ${_processedFiles.length} file';
          });

          // Aggiungi un delay tra i download per evitare problemi con il browser
          await Future.delayed(const Duration(milliseconds: 50));
        } catch (e) {
          print('Errore nel download del file ${processedFile.fileName}: $e');
          // Continua con il prossimo file anche se questo fallisce
        }
      }

      setState(() {
        _status = 'Tutti i file sono stati scaricati con successo!';
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
        title: const Text('Convertitore CSV'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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

              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _processFiles,
                  icon: const Icon(Icons.file_upload),
                  label: const Text(
                    'Seleziona File',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              if (_processedFiles.isNotEmpty) ...[
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _downloadAllFiles,
                  icon: const Icon(Icons.download),
                  label: const Text(
                    'Scarica Tutti',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _processedFiles.length,
                    itemBuilder: (context, index) {
                      final file = _processedFiles[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(file.fileName),
                          trailing: IconButton(
                            icon: Icon(
                              file.isProcessed ? Icons.check_circle : Icons.download,
                              color: file.isProcessed ? Colors.green : Colors.blue,
                            ),
                            onPressed: () => _downloadFile(file),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
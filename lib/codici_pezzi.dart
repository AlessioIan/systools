import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ComponentCode {
  final String code;
  final String description;
  
  ComponentCode({
    required this.code,
    required this.description,
  });
}

class CodiciPezziPage extends StatefulWidget {
  const CodiciPezziPage({super.key});

  @override
  State<CodiciPezziPage> createState() => _CodiciPezziPageState();
}

class _CodiciPezziPageState extends State<CodiciPezziPage> {
  bool _isEditMode = false;
  String _searchQuery = '';
  List<ComponentCode> _allComponents = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allComponents = [
      ComponentCode(code: '495608', description: 'Light protection 3.2x1.6 mm'),
      ComponentCode(code: '116-0536-06', description: 'Tygon tubing 0.64mm'),
      ComponentCode(code: '116-0536-10', description: 'Tygon tubing 1.14mm'),
      ComponentCode(code: '116-0536-14', description: 'Tygon tubing 1.85mm'),
      ComponentCode(code: '116-0536-15', description: 'Tygon tubing 2.06mm'),
      ComponentCode(code: '176.766-15-40', description: 'FLOW CELL QUARTZ 10x2 mm centro 15'),
      ComponentCode(code: '176.766-QS', description: 'FLOW CELL QUARTZ 10x2 mm centro 8.5'),
      ComponentCode(code: '176-751-QS', description: 'FLOW CELL QUARTZ 3x3 mm centro 8.5'),
      ComponentCode(code: '176-754-QS', description: 'FLOW CELL QUARTZ 10x2.5 mm'),
      ComponentCode(code: '178-0539-05', description: 'Norprene Yellow/Orange'),
      // Aggiungi qui gli altri componenti
    ];
  }

  List<ComponentCode> get _filteredComponents {
    if (_searchQuery.isEmpty) return _allComponents;
    return _allComponents.where((component) {
      final searchLower = _searchQuery.toLowerCase();
      return component.code.toLowerCase().contains(searchLower) ||
             component.description.toLowerCase().contains(searchLower);
    }).toList();
  }

  Future<void> _exportToExcel() async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Codici Componenti'];

      // Intestazioni
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value = TextCellValue('Codice');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value = TextCellValue('Descrizione');

      // Dati
      for (var i = 0; i < _filteredComponents.length; i++) {
        final component = _filteredComponents[i];
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1)).value = TextCellValue(component.code);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1)).value = TextCellValue(component.description);
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/codici_componenti.xlsx');
      await file.writeAsBytes(excel.encode()!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File Excel esportato con successo')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nell\'esportazione: $e')),
        );
      }
    }
  }

  Future<void> _addOrEditComponent(ComponentCode? component) async {
    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController(text: component?.code ?? '');
    final descriptionController = TextEditingController(text: component?.description ?? '');
    final isUpdate = component != null;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isUpdate ? 'Modifica Componente' : 'Nuovo Componente'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    labelText: 'Codice',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci un codice';
                    }
                    // Verifica che il codice non sia già in uso (tranne che per lo stesso componente in modifica)
                    if (isUpdate && value != component.code) {
                      if (_allComponents.any((c) => c.code == value)) {
                        return 'Questo codice è già in uso';
                      }
                    } else if (!isUpdate) {
                      if (_allComponents.any((c) => c.code == value)) {
                        return 'Questo codice è già in uso';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrizione',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci una descrizione';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final newComponent = ComponentCode(
                  code: codeController.text.trim(),
                  description: descriptionController.text.trim(),
                );

                setState(() {
                  if (isUpdate) {
                    // Rimuovi il vecchio componente e aggiungi quello nuovo
                    _allComponents.removeWhere((c) => c.code == component.code);
                    _allComponents.add(newComponent);
                    // Ordina la lista per codice
                    _allComponents.sort((a, b) => a.code.compareTo(b.code));
                  } else {
                    // Aggiungi nuovo componente
                    _allComponents.add(newComponent);
                    // Ordina la lista per codice
                    _allComponents.sort((a, b) => a.code.compareTo(b.code));
                  }
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isUpdate 
                      ? 'Componente aggiornato con successo' 
                      : 'Nuovo componente aggiunto'),
                  ),
                );
              }
            },
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }

  void _deleteComponent(ComponentCode component) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conferma eliminazione'),
        content: Text('Sei sicuro di voler eliminare il componente ${component.code}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      setState(() {
        _allComponents.removeWhere((c) => c.code == component.code);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Componente eliminato con successo')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Codici Componenti'),
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.lock : Icons.lock_open),
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode;
              });
            },
            tooltip: _isEditMode ? 'Disabilita modifiche' : 'Abilita modifiche',
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportToExcel,
            tooltip: 'Esporta in Excel',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cerca',
                hintText: 'Cerca per codice o descrizione',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _filteredComponents.isEmpty
                ? Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'Nessun componente presente'
                          : 'Nessun risultato trovato',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredComponents.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final component = _filteredComponents[index];
                      return ListTile(
                        title: Text(
                          component.code,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(component.description),
                        trailing: _isEditMode
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _addOrEditComponent(component),
                                    tooltip: 'Modifica',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteComponent(component),
                                    tooltip: 'Elimina',
                                  ),
                                ],
                              )
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _isEditMode
          ? FloatingActionButton(
              onPressed: () => _addOrEditComponent(null),
              tooltip: 'Aggiungi componente',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
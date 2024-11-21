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
      ComponentCode(code: '178-6275-03', description: 'TUBE AND REAGENT STRAW (TEFLON TUBE 1.6x3.2)'),
      ComponentCode(code: '178-6275-03A1', description: 'REAGENT STRAW TEFLON 1,6X3.2   30 CM Cleaning'),
      ComponentCode(code: '178-6275-03B1', description: 'STRAW 1,6x3,2 TEFLON 40CM H20'),
      ComponentCode(code: '178-6275-03C1', description: 'REAGENT STRAW TEFLON 1,6X3.2   20 CM Calibrant'),
      ComponentCode(code: '562-0005-01', description: 'TYGON 1/8X1/4" LARGE'),
      ComponentCode(code: '562-3019-X1', description: 'TUBING TEFLON 1 x 1.5 mm (reag. tube)'),
      ComponentCode(code: '562-3019-X2', description: 'TUBING TEFLON 1.6 x 3.2 mm (manifold)'),
      ComponentCode(code: '562-3019-X3', description: 'Teflon tubing'),
      ComponentCode(code: '562-3019-X5', description: 'Cristal tube PFA 1,6x3,2 mm'),
      ComponentCode(code: '562-3050-X2', description: 'TUBING SILICONE 1.8X4.0 mm'),
      ComponentCode(code: 'BAG-CONN-02', description: 'CONNECTOR FOR F/C AND PUMP TUBE'),
      ComponentCode(code: 'BI-16/24', description: 'N7 nipple small/medium'),
      ComponentCode(code: 'BI-24/32', description: 'N6 nipple big/medium'),
      ComponentCode(code: 'BPT-0206-008', description: 'Tube 206'),
      ComponentCode(code: 'COD-COND-30', description: 'SMALL CONDENSER'),
      ComponentCode(code: 'COD-DGEST-05A', description: 'DIGESTER QUARTZ WITH RESISTOR'),
      ComponentCode(code: 'COD-DIGEST-06', description: 'SMALL GLASS DIGESTER WITH RESISTOR 13mL'),
      ComponentCode(code: 'COD-DIGEST-07', description: 'BIG GLASS DIGESTER WITH RESISTOR'),
      ComponentCode(code: 'CP96410-16', description: 'Tubo pompa silicone 16'),
      ComponentCode(code: 'CPU-DISK-01', description: 'DISK ON MODULE FOR CPU-PC104-04'),
      ComponentCode(code: 'CPU-PC104-04', description: 'CPU BOARD PC104 (USB VERSION) WITHOUT DISK ON MODULE'),
      ComponentCode(code: 'DI-016', description: 'N8 nipple small/small'),
      ComponentCode(code: 'DI-032', description: 'Nipple Big/Big'),
      ComponentCode(code: 'FLT-0025-00', description: 'FILTRO 25 MICRON'),
      ComponentCode(code: 'FLT-100-00', description: 'FILTRO 100 MICRON'),
      ComponentCode(code: 'FLT-400-00', description: 'FILTRO 400 MICRON'),
      ComponentCode(code: 'GEN-PLBT-04', description: 'Bottiglia plastica 500 mL'),
      ComponentCode(code: 'LD-024', description: 'L CONNECTOR medium/medium'),
      ComponentCode(code: 'LM317', description: 'LM317'),
      ComponentCode(code: 'MM10459-00', description: 'LARGE T CONNECTION 4 mm'),
      ComponentCode(code: 'MOD.L4960', description: 'L4960'),
      ComponentCode(code: 'OR-115-NBR', description: 'O-rings for electrode cell'),
      ComponentCode(code: 'PRS-SNSR-01', description: 'SAMPLE PRESENCE DETECTOR'),
      ComponentCode(code: 'PWR-MICC-01', description: 'POWER SUPPLY MICROMAC C 12 VDC'),
      ComponentCode(code: 'STA-ACDC-12', description: 'POWER SUPPLY 100/240VAC-12VDC'),
      ComponentCode(code: 'STA-ADPT-01', description: 'KEYBOARD DISPLAY ADAPTOR BOARD'),
      ComponentCode(code: 'STA-BATH-01', description: 'HEATING BATH 20T LOW TEMPERATURE INTERNAL - LFA ANALYZER (TEFLON)'),
      ComponentCode(code: 'STA-BATH-02', description: 'HEATING BATH FLOW CELL (WITHOUT FLOW CELL)'),
      ComponentCode(code: 'STA-BATH-03', description: 'HEATING BATH HIGH TEMPERATURE (TEFLON)'),
      ComponentCode(code: 'STA-BATH-50', description: 'HB FLOW CELL & 50mm FLOW CELL ASSY'),
      ComponentCode(code: 'STA-COLOR-01', description: 'COLORIMETER PREAMPLIFIER BOARD'),
      ComponentCode(code: 'STA-CONN-01', description: 'NUT ADAPTER for PUMP TUBE'),
      ComponentCode(code: 'STA-DISP-03', description: 'LFA ANALYZER DISPLAY, PARALLEL/GRAPHICS MODIFIED FOR NEW CPU-PC104-04 (WITH USB PORT)'),
      ComponentCode(code: 'STA-DISP-06', description: 'TS DISPLAY'),
      ComponentCode(code: 'STA-DISPASSY-02', description: 'DISPLAY PG'),
      ComponentCode(code: 'STA-F410-01', description: 'FILTER 410 nm 10 mm'),
      ComponentCode(code: 'STA-F420-01', description: 'FILTER 420 nm 10 mm'),
      ComponentCode(code: 'STA-F450-01', description: 'FILTER 450 nm 10 mm'),
      ComponentCode(code: 'STA-F460-01', description: 'FILTER 460 nm 10 mm'),
      ComponentCode(code: 'STA-F470-01', description: 'FILTER 470 nm 10 mm'),
      ComponentCode(code: 'STA-F480-01', description: 'FILTER 480 nm 10 mm'),
      ComponentCode(code: 'STA-F505-01', description: 'FILTER 505 nm 10 mm'),
      ComponentCode(code: 'STA-F510-01', description: 'FILTER 510 nm 10 mm'),
      ComponentCode(code: 'STA-F520-01', description: 'FILTER 520 nm 10 mm'),
      ComponentCode(code: 'STA-F530-01', description: 'FILTER 530 nm 10 mm'),
      ComponentCode(code: 'STA-F550-01', description: 'FILTER 550 nm 10 mm'),
      ComponentCode(code: 'STA-F560-01', description: 'FILTER 560 nm 10 mm'),
      ComponentCode(code: 'STA-F570-01', description: 'FILTER 570 nm 10 mm'),
      ComponentCode(code: 'STA-F600-01', description: 'FILTER 600 nm 10 mm'),
      ComponentCode(code: 'STA-F620-01', description: 'FILTER 620 nm 10 mm'),
      ComponentCode(code: 'STA-F630-01', description: 'FILTER 630 nm 10 mm'),
      ComponentCode(code: 'STA-F650-01', description: 'FILTER 650 nm 10 mm'),
      ComponentCode(code: 'STA-F660-01', description: 'FILTER 660 nm 10 mm'),
      ComponentCode(code: 'STA-F700-01', description: 'FILTER 700 nm 10 mm'),
      ComponentCode(code: 'STA-F820-01', description: 'FILTER 820 nm 10 mm'),
      ComponentCode(code: 'STA-F880-01', description: 'FILTER 880 nm 10 mm'),
      ComponentCode(code: 'STA-FER-03', description: 'BLUE FERULA FOR TEFLON 1,0X1,5 (Reagent valve connection)'),
      ComponentCode(code: 'STA-FLANG-00', description: 'FLANGING TOOL (TO FLANGE TUBE 1.6x3.2)'),
      ComponentCode(code: 'STA-FLAT-01', description: 'FLAT CABLE DISPLAY BOARD/MMAC-03 BOARD'),
      ComponentCode(code: 'STA-FLAT-02', description: 'FLAT CABLE DISPLAY BOARD/CPU BOARD (CPU-PC104-04)'),
      ComponentCode(code: 'STA-FLAT-03', description: 'FLAT CABLE MPIO BOARD/RFIO BOARD'),
      ComponentCode(code: 'STA-FLAT-04', description: 'FLAT CABLE MPIO BOARD/MMAC03 BOARD'),
      ComponentCode(code: 'STA-FLAT-50', description: 'FLAT CABLE 50 PIN MICROMAC C'),
      ComponentCode(code: 'STA-KEYP-02', description: 'LFA ANALYZER KEYPAD, NEW WITH LOGO'),
      ComponentCode(code: 'STA-L430-01F5', description: 'EMITTER 430 nm, 5 mm dia'),
      ComponentCode(code: 'STA-L470-01F3', description: 'Emitter led 470 nm, 3 mm'),
      ComponentCode(code: 'STA-L470-01F5', description: 'Emitter led 470 nm, 5 mm'),
      ComponentCode(code: 'STA-L500-01F5', description: 'Emitter led 500nm'),
      ComponentCode(code: 'STA-L592-01F5', description: 'Emitter led 592nm'),
      ComponentCode(code: 'STA-L609-01F5', description: 'Emitter led 609 nm'),
      ComponentCode(code: 'STA-L660-01F5A', description: 'Emitter led 660 nm'),
      ComponentCode(code: 'STA-L850-01F5B', description: 'EMITTER 850 nm, single LED analyzers'),
      ComponentCode(code: 'STA-L880-01F5A', description: 'Emitter led 880 nm'),
      ComponentCode(code: 'STA-M098-00', description: 'REACTION CYLINDER BOTTOM PART'),
      ComponentCode(code: 'STA-M099-03', description: 'CYLINDER TOP 6 REAGENTS'),
      ComponentCode(code: 'STA-M100-02', description: 'REACTION CYLINDER ASSY 4 REAG. +AIR (SILICON MANIFOLD)- STA-M098-00+STA-M099-02'),
      ComponentCode(code: 'STA-M101-00', description: 'COLORIMETER ASSY'),
      ComponentCode(code: 'STA-M101-01', description: 'FLOW CELL 50mm'),
      ComponentCode(code: 'STA-M101-02', description: 'FLOW CELL 15mm'),
      ComponentCode(code: 'STA-M102-00', description: 'FLOW CELL HOLDER -UNIVERSAL; EX STA-M101-01'),
      ComponentCode(code: 'STA-M103-02', description: 'PUMP HEAD MIC C & MIC 1000'),
      ComponentCode(code: 'STA-M103-02', description: 'PUMP HEAD MIC C - 7016'),
      ComponentCode(code: 'STA-M103-03', description: 'Pump tube 16'),
      ComponentCode(code: 'STA-M103-03/A', description: 'Pump tubes small'),
      ComponentCode(code: 'STA-M103-03/B', description: 'Pump tube meduim'),
      ComponentCode(code: 'STA-M103-03/C', description: 'Pump tube large'),
      ComponentCode(code: 'STA-M103-04', description: 'PUMP TUBE, ON LINE FILTER'),
      ComponentCode(code: 'STA-M103-06', description: 'Pump tube 14'),
      ComponentCode(code: 'STA-M103-08', description: 'PUMP HEAD MIC C 7014'),
      ComponentCode(code: 'STA-M103-14', description: 'MOTOR BRUSH. 12 VDC 40 RPM'),
      ComponentCode(code: 'STA-M103-14', description: 'MOTOR PUMP MIC C - 71'),
      ComponentCode(code: 'STA-M103-26', description: 'BRUSHLESS MOTOR 12V - 100 RPM - 1/27'),
      ComponentCode(code: 'STA-M103-32', description: 'PUMP HEAD 7013-20 MIC C'),
      ComponentCode(code: 'STA-M103-41', description: 'Peristaltic pump runze fluid'),
      ComponentCode(code: 'STA-M104-01', description: 'PUMP MOTOR ON LINE FILTER'),
      ComponentCode(code: 'STA-M105-05', description: '2 Way N.O. valve JUOCOMATIC'),
      ComponentCode(code: 'STA-M105-06', description: '3 Way valve JOUCOMATIC'),
      ComponentCode(code: 'STA-M105-07', description: '2 Way N.C. valve JUOCOMATIC'),
      ComponentCode(code: 'STA-M105-12', description: '2 WAY VALVE (SMC)'),
      ComponentCode(code: 'STA-M105-13', description: '3 Way valve SMC'),
      ComponentCode(code: 'STA-M105-16', description: '3 Way valve SMC'),
      ComponentCode(code: 'STA-M105-16K', description: '3 Way valve SMC KALREZ'),
      ComponentCode(code: 'STA-M105-17', description: 'EPDM VALVE'),
      ComponentCode(code: 'STA-M105-18', description: '2 WAY VALVE MANIFOLD TYPE (SMC)'),
      ComponentCode(code: 'STA-M105-21K', description: '3 WAY VALVE SIRAI BARBED (Kalrez)'),
      ComponentCode(code: 'STA-M105-28', description: '2 WAY VALVE TEFLON Takasago'),
      ComponentCode(code: 'STA-M105-30', description: '2 WAY VALVE Parker (Teflon)'),
      ComponentCode(code: 'STA-M106-03', description: 'MANIFOLD 3 POSITION FOR STA-M105-16 AND STA-M105-16K'),
      ComponentCode(code: 'STA-M106-04', description: 'T CONNECTOR TEFLON MANIFOLD'),
      ComponentCode(code: 'STA-M106-06', description: 'Valve manifold in PVC'),
      ComponentCode(code: 'STA-M106-09', description: 'MANIFOLD PTFE 3 POSITION FOR STA-M105-16 AND STA-M105-16K'),
      ComponentCode(code: 'STA-MMAC-03/F', description: 'POWER SUPPLY DRIVER SINGLE LED COLO - NEW (graphic/parallel display)'),
      ComponentCode(code: 'STA-NUT-00', description: 'NUT CLOSED'),
      ComponentCode(code: 'STA-NUT-03', description: 'BLACK NUT FOR TEFLON 1,0x1,5 (Reagent valve connection)'),
      ComponentCode(code: 'STA-NUT-F01', description: 'NUT BLACK for to flanged crystal tube 562-3019-X5'),
      ComponentCode(code: 'STA-NUT-F01', description: 'BLACK NUT FOR FLANGED TUBING 1.6x3.2'),
      ComponentCode(code: 'STA-ORING-01', description: 'O-RING RILSAN FOR STA-M105-12'),
      ComponentCode(code: 'STA-ORING-02', description: 'WASHER PVC FOR FLANGED TUBIUNG 1.6x3.2'),
      ComponentCode(code: 'STA-ORING-03', description: 'ORING 3x1 FOR FLANGE TUBING'),
      ComponentCode(code: 'STA-PROV-04', description: 'Provetta piccola per filtro'),
      ComponentCode(code: 'STA-RFIO-04C', description: 'DRIVER BOARD NEW (Micromac C)'),
      ComponentCode(code: 'STA-UVLM-01', description: 'UV LAMP'),
      ComponentCode(code: 'STA-XNLM-01A', description: 'XENON LAMP TNTP ASSY'),
      ComponentCode(code: 'SYM-ISEL-01', description: 'SYM-ISEL BOARD'),
      ComponentCode(code: 'SYM-MMAC-02', description: 'NEW BOARD'),
      ComponentCode(code: 'SYM-MMAC-05', description: 'KEYBOARD INTERFACE BOARD; PARALL/GRAPH DISPLAY'),
      ComponentCode(code: 'SYM-MPIO-02', description: 'I/O BOARD FOR CPU-PC104-00'),
      ComponentCode(code: 'STA-M103-26B', description: 'Booster board for motor 027'),
      ComponentCode(code: 'STA-M105-36K', description: '3 Way valve KETYTO KALREZ'),
      ComponentCode(code: 'SYM-PRPT-01', description: 'INTERCONNECTION BOARD'),
      ComponentCode(code: 'SYM-SMPR-03A', description: 'SAMPLE PRESENCE DETECTOR'),
      ComponentCode(code: 'T-024', description: 'T CONNECTOR PP'),
      ComponentCode(code: 'VTB4051H-A', description: 'SAMPLE/REFERENCE SENSOR'),
      ComponentCode(code: 'X000UB187J', description: 'TEMPERATURE BOARD'),
      ComponentCode(code: 'XTR110KP', description: 'ELECTRONIC COMPONENT 4-20mA'),
      ComponentCode(code: 'SYM-SMPR-03A', description: 'SAMPLE PRESENCE SENSOR'),
      ComponentCode(code: 'STA-CDCL-03', description: 'Cationic column pexiglas 150x12mm'),
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
import 'package:flutter/material.dart';
//è una lista di comandi. i comandi stanno scritti in questa pagina
// Modello per i dati dei comandi
class Command {
  final String code;
  final String sec;
  final String tic;
  final String description;

  Command({
    required this.code,
    required this.sec,
    required this.tic,
    required this.description,
  });
}

class ListaDeiComandi extends StatefulWidget {
  const ListaDeiComandi({super.key});

  @override
  State<ListaDeiComandi> createState() => _ListaDeiComandiState();
}

class _ListaDeiComandiState extends State<ListaDeiComandi> {
  final List<Command> commands = [];
  List<Command> filteredCommands = [];
  final TextEditingController searchController = TextEditingController();
  String searchType = 'code';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    filteredCommands = List.from(commands);
  }

  void _loadInitialData() {
    commands.addAll([
      
      Command(code: '50', sec: '50', tic: '', description: 'SAMPLE'),
      Command(code: '51', sec: '51', tic: '', description: 'LOOP'),
      Command(code: '52', sec: '52', tic: 'X', description: 'PUMP DIRECT FAST'),
      Command(code: '53', sec: '53', tic: '', description: 'ATTIVA V6 E POMPA IN REVERSE'),
      Command(code: '54', sec: '54', tic: '', description: 'VACUUM RED.'),
      Command(code: '55', sec: '55', tic: '', description: 'SPEGNE LE VALVOLE V5/V6/V7'),
      Command(code: '56', sec: '56', tic: '', description: 'MIXING'),
      Command(code: '57', sec: '57', tic: '', description: 'REACTION'),
      Command(code: '58', sec: '58', tic: '', description: 'Pompa in fast e stacca da V1 a V7'),
      Command(code: '59', sec: '59', tic: '', description: 'ATTIVA V6/V7 E POMPA IN REVERSE'),
      Command(code: '60', sec: '60', tic: '', description: 'WASH VALVE'),
      Command(code: '61', sec: '61', tic: '', description: 'ATTIVA V5/V6/ E POMPA IN DIRECT FAST'),
      Command(code: '62', sec: '62', tic: '', description: 'CYCLE END'),
      Command(code: '63', sec: '63', tic: '', description: 'VALVE 5 ON'),
      Command(code: '64', sec: '64', tic: '', description: 'OFF VALVE from V1 to V7'),
      Command(code: '65', sec: '65', tic: '', description: 'OFF MOTORS PAUSE'),
      Command(code: '66', sec: '66', tic: '', description: 'T . ON (V12)'),
      Command(code: '67', sec: '67', tic: '', description: 'RESULTS IN MEMORY'),
      Command(code: '68', sec: '68', tic: '', description: 'RIT. T .... R'),
      Command(code: '69', sec: '69', tic: '', description: 'V1 INJECTION'),
      Command(code: '70', sec: '70', tic: '', description: 'V2 INJECTION'),
      Command(code: '71', sec: '71', tic: '', description: 'V3 INJECTION'),
      Command(code: '72', sec: '72', tic: '', description: 'V4 INJECTION'),
      Command(code: '73', sec: '73', tic: '', description: 'V3 KWN ADD'),
      Command(code: '74', sec: '74', tic: '', description: 'VK4 INJECTION'),
      Command(code: '75', sec: '75', tic: '', description: 'VK5 INJECTION'),
      Command(code: '76', sec: '76', tic: '', description: 'W. TR LFR'),
      Command(code: '77', sec: '77', tic: '', description: 'W. TRGH V5'),
      Command(code: '78', sec: '78', tic: '', description: 'V9 OFF'),
      Command(code: '79', sec: '79', tic: '', description: 'V9 ON'),
      Command(code: '80', sec: '80', tic: '', description: 'OFF VALVE from V9 to V12'),
      Command(code: '81', sec: '81', tic: '', description: 'LATCH IN V1'),
      Command(code: '82', sec: '82', tic: '', description: 'LATCH OUT V1'),
      Command(code: '83', sec: '83', tic: 'x', description: 'Pump slow: TIC=0 Direct; TIC=1 Reverse; Time= activation time'),
      Command(code: '84', sec: '84', tic: '', description: 'COL WASH'),
      Command(code: '85', sec: '85', tic: '', description: 'LATCH IN V2'),
      Command(code: '86', sec: '86', tic: '', description: 'LATCH OUT V2'),
      Command(code: '87', sec: '87', tic: '', description: 'SAMPLE WASH DILUENT'),
      Command(code: '88', sec: '88', tic: '', description: 'DIL. FILL DILUENT'),
      Command(code: '89', sec: '89', tic: '', description: 'SAMPLE V9 AND V11'),
      Command(code: '90', sec: '90', tic: '', description: 'PRIME WASH V9 & V11'),
      Command(code: '91', sec: '91', tic: '', description: 'PRIME WASH IN V5'),
      Command(code: '92', sec: '92', tic: '', description: 'STORE PK POINT'),
      Command(code: '93', sec: '93', tic: '', description: 'BLANK SAMPLE'),
      Command(code: '94', sec: '94', tic: '', description: 'SET FLAG 4 MIN.'),
      Command(code: '95', sec: '95', tic: '', description: 'RESET FLAG 4 MIN.'),
      Command(code: '96', sec: '96', tic: '', description: 'V3 ON FIX'),
      Command(code: '97', sec: '97', tic: '', description: 'OFF VALVE V1..V4'),
      Command(code: '98', sec: '98', tic: '', description: 'SET FLAG VN MONO'),
      Command(code: '99', sec: '99', tic: '', description: 'RESET FLAG VN'),
      Command(code: '100', sec: '100', tic: '', description: 'SAMPLE'),
      Command(code: '101', sec: '101', tic: '', description: 'LOOP'),
      Command(code: '102', sec: '102', tic: '', description: 'SET DIL V'),
      Command(code: '103', sec: '103', tic: '', description: 'RESET DIL V'),
      Command(code: '104', sec: '104', tic: '', description: 'PUMP 2 ON'),
      Command(code: '105', sec: '105', tic: '', description: 'PUMP 2 OFF'),
      Command(code: '106', sec: '106', tic: '', description: 'FILL LFR SLOW'),
      Command(code: '107', sec: '107', tic: '', description: 'V11 ON'),
      Command(code: '108', sec: '108', tic: '', description: 'V11 OFF'),
      Command(code: '109', sec: '109', tic: '', description: 'V10 ON'),
      Command(code: '110', sec: '110', tic: '', description: 'V10 OFF'),
      Command(code: '114', sec: '114', tic: '', description: 'V3 ON'),
      Command(code: '115', sec: '115', tic: '', description: 'V3 OFF'),
      Command(code: '116', sec: '116', tic: '', description: 'V4 ON'),
      Command(code: '117', sec: '117', tic: '', description: 'V4 OFF'),
      Command(code: '118', sec: '118', tic: '', description: 'V5 ON'),
      Command(code: '119', sec: '119', tic: '', description: 'V5 OFF'),
      Command(code: '120', sec: '120', tic: '', description: 'V6 ON'),
      Command(code: '121', sec: '121', tic: '', description: 'V6 OFF'),
      Command(code: '122', sec: '122', tic: '', description: 'V7 ON'),
      Command(code: '123', sec: '123', tic: '', description: 'V7 OFF'),
      Command(code: '124', sec: '124', tic: '', description: 'V8 ON'),
      Command(code: '125', sec: '125', tic: '', description: 'V8 OFF'),
      Command(code: '126', sec: '126', tic: '', description: 'READ O.D. H2O'),
      Command(code: '128', sec: '128', tic: '', description: 'K4 ON'),
      Command(code: '129', sec: '129', tic: '', description: 'K4 OFF'),
      Command(code: '130', sec: '130', tic: '', description: 'K5 ON'),
      Command(code: '131', sec: '131', tic: '', description: 'K5 OFF'),
      Command(code: '132', sec: '132', tic: '', description: 'K6 ON'),
      Command(code: '133', sec: '133', tic: '', description: 'K6 OFF'),
      Command(code: '134', sec: '134', tic: '', description: 'K7 ON'),
      Command(code: '135', sec: '135', tic: '', description: 'K7 OFF'),
      Command(code: '136', sec: '136', tic: '', description: 'K8 ON'),
      Command(code: '137', sec: '137', tic: '', description: 'K8 OFF'),
      Command(code: '138', sec: '138', tic: '', description: 'VK6 INJECTION'),
      Command(code: '139', sec: '139', tic: '', description: 'VK7 INJECTION'),
      Command(code: '140', sec: '140', tic: '', description: 'VK8 INJECTION'),
      Command(code: '145', sec: '145', tic: '', description: 'VX1 ON'),
      Command(code: '146', sec: '146', tic: '', description: 'VX1 OFF'),
      Command(code: '147', sec: '147', tic: '', description: 'VX2 ON'),
      Command(code: '148', sec: '148', tic: '', description: 'VX2 OFF'),
      Command(code: '149', sec: '149', tic: '', description: 'VX3 ON'),
      Command(code: '150', sec: '150', tic: '', description: 'VX3 OFF'),
      Command(code: '151', sec: '151', tic: '', description: 'VX4 ON'),
      Command(code: '152', sec: '152', tic: '', description: 'VX4 OFF'),
      Command(code: '153', sec: '153', tic: '', description: 'VX5 ON'),
      Command(code: '154', sec: '154', tic: '', description: 'VX5 OFF'),
      Command(code: '155', sec: '155', tic: '', description: 'VX6 ON'),
      Command(code: '156', sec: '156', tic: '', description: 'VX6 OFF'),
      Command(code: '157', sec: '157', tic: '', description: 'VX7 ON'),
      Command(code: '158', sec: '158', tic: '', description: 'VX8 OFF'),
      Command(code: '159', sec: '159', tic: '', description: 'VX8 ON'),
      Command(code: '160', sec: '160', tic: '', description: 'VX8 OFF'),
      Command(code: '161', sec: '161', tic: '', description: 'VC1 ON'),
      Command(code: '162', sec: '162', tic: '', description: 'VC1 OFF'),
      Command(code: '163', sec: '163', tic: '', description: 'VC2 ON'),
      Command(code: '164', sec: '164', tic: '', description: 'VC2 OFF'),
      Command(code: '165', sec: '165', tic: '', description: 'VC3 ON'),
      Command(code: '166', sec: '166', tic: '', description: 'VC3 OFF'),
      Command(code: '167', sec: '167', tic: '', description: 'VC4 ON'),
      Command(code: '168', sec: '168', tic: '', description: 'VC4 OFF'),
      Command(code: '169', sec: '169', tic: '', description: 'VC5 ON'),
      Command(code: '170', sec: '170', tic: '', description: 'VC5 OFF'),
      Command(code: '171', sec: '171', tic: '', description: 'VC6 ON'),
      Command(code: '172', sec: '172', tic: '', description: 'VC6 OFF'),
      Command(code: '173', sec: '173', tic: '', description: 'VC7 ON'),
      Command(code: '174', sec: '174', tic: '', description: 'VC7 OFF'),
      Command(code: '175', sec: '175', tic: '', description: 'VC8 ON'),
      Command(code: '176', sec: '176', tic: '', description: 'VC8 OFF'),
      Command(code: '177', sec: '177', tic: 'X', description: 'V10 dilution ON/OFF: time = ON; Tic = OFF'),
      Command(code: '178', sec: '178', tic: 'X', description: 'VC4 dilution ON/OFF: time = ON; Tic = OFF'),
      Command(code: '179', sec: '179', tic: '0', description: 'This command resets the dilution for V8 V10 VC3 VC4 VC5 and VC6 with flip flop action'),
      Command(code: '180', sec: '180', tic: '', description: 'START MEM POINTS'),
      Command(code: '181', sec: '181', tic: '', description: 'VC1 INJECTION'),
      Command(code: '182', sec: '182', tic: '', description: 'VC2 INJECTION'),
      Command(code: '183', sec: '183', tic: '', description: 'VC3 INJECTION'),
      Command(code: '184', sec: '184', tic: '', description: 'VC4 INJECTION'),
      Command(code: '185', sec: '185', tic: '', description: 'NON SAMPLE STOP'),
      Command(code: '186', sec: '186', tic: '', description: 'SAMPLE DETECT ON'),
      Command(code: '187', sec: '187', tic: '', description: 'SAMPLE DETECT OFF'),
      Command(code: '188', sec: '188', tic: '0', description: 'Set dilution to OFF for this method'),
      Command(code: '189', sec: '189', tic: '', description: 'SET FLAG DIL=1'),
      Command(code: '190', sec: '190', tic: '', description: 'INP 3 (WALTRON I STR)'),
      Command(code: '191', sec: '191', tic: '', description: 'INP 4 (WALTRON II STR)'),
      Command(code: '192', sec: '192', tic: '', description: 'K1 ON'),
      Command(code: '193', sec: '193', tic: '', description: 'K2 ON'),
      Command(code: '194', sec: '194', tic: '', description: 'K3 ON'),
      Command(code: '195', sec: '195', tic: '0', description: 'Busy OFF: this command forces the Busy rele to OFF position, used to restart an output connected to the Busy rele'),
      Command(code: '196', sec: '196', tic: '', description: 'PUMP ON'),
      Command(code: '197', sec: '197', tic: '', description: 'INP AIR(For Valter MC Cn)'),
      Command(code: '198', sec: '198', tic: '', description: 'TUBE NOT EMPTY'),
      Command(code: '199', sec: '199', tic: '0 o 1', description: 'Exit to main menu; if TIC is 0 system exits, if tic is 1 system exits but does not reset outputs (pump and valves and temperature on)'),
      Command(code: '200', sec: '200', tic: '0', description: 'The analysis jumps directly to the dilution cycle : normally this command is at beginning of cycle'),
      Command(code: '201', sec: '201', tic: '0', description: 'V1 impulse stroke for dosing with micropump, used for V1 control: number of strokes = dosing time'),
      Command(code: '202', sec: '202', tic: '0', description: 'V2 impulse stroke for dosing with micropump, used for V2 control: number of strokes = dosing time'),
      Command(code: '205', sec: '205', tic: '0', description: 'Timestamp for date: this command can be set anywhere is cycle to store the date as analysis date'),
      Command(code: '206', sec: '206', tic: '0', description: 'Timestamp for time: this command can be set anywhere is cycle to store the time as analysis time'),
      Command(code: '208', sec: '208', tic: '0', description: 'Sample detector on for Air (check for detector in air. The sensor must be with light on)'),
      Command(code: '209', sec: '209', tic: '', description: 'Check for liquid/3'),
      Command(code: '210', sec: '210', tic: '0', description: 'DAC=X: command used to set the DAC value of digital control for LED power'),
      Command(code: '211', sec: '211', tic: '0', description: 'Autozero colorimeter: command to start the autozero cycle when present'),
      Command(code: '212', sec: '212', tic: '', description: 'Fluorimeter Led ON'),
      Command(code: '213', sec: '213', tic: '0', description: 'Temperature HB2 OFF: command to switch off the second HB'),
      Command(code: '214', sec: '214', tic: '0', description: 'Temperature HB2 ON'),
      Command(code: '215', sec: '215', tic: '', description: 'COOLING'),
      Command(code: '216', sec: '216', tic: '0', description: 'VC5 dilution ON/OFF: time = ON; Tic = OFF'),
      Command(code: '217', sec: '217', tic: '0', description: 'V8 dilution ON/OFF: time = ON; Tic = OFF'),
      Command(code: '218', sec: '218', tic: '0', description: 'VC3 dilution ON/OFF: time = ON; Tic = OFF'),
      Command(code: '219', sec: '219', tic: '0', description: 'VC6 dilution ON/OFF: time = ON; Tic = OFF'),
      Command(code: '220', sec: '220', tic: '0', description: 'Concentration calculation TN TP'),
      Command(code: '221', sec: '221', tic: '0', description: 'Show results'),
      Command(code: '222', sec: '222', tic: '0', description: 'Analog outputs'),
      Command(code: '225', sec: '225', tic: '0', description: 'Measuring mV (Tic 0-3= meth 0-3)'),
      Command(code: '230', sec: '230', tic: 'X', description: 'Copia la calibrazione del metodo 0 se X=0 ; 1 se X=1 etc..'),
      Command(code: '231', sec: '231', tic: 'X', description: 'Copia il bianco del metodo 0 se X=0 ; 1 se X=1 etc..'),
      Command(code: '232', sec: '232', tic: '0', description: 'mV Reading for pH4'),
      Command(code: '232', sec: '232', tic: '1', description: 'mV Reading for pH7'),
      Command(code: '232', sec: '232', tic: '2', description: 'mV Reading for pH10'),
      Command(code: '233', sec: '233', tic: '0', description: 'Slope calculation for pH method'),
      Command(code: '240', sec: '240', tic: '0', description: 'E1 reading (Tic 0-3= meth 0-3)'),
      Command(code: '241', sec: '241', tic: '0', description: 'E2 reading (Tic 0-3= meth 0-3)'),
      Command(code: '242', sec: '242', tic: '0', description: 'Slope calculation (Tic 0-3= meth 0-3)'),
      Command(code: '243', sec: '243', tic: '0', description: 'Read E0 mV (specific for method: TIC 0-3= meth 0-3)'),
      Command(code: '245', sec: '245', tic: '0', description: 'Mode ISE ON'),
      Command(code: '249', sec: 'CH', tic: 'Fact', description: 'correlation between COD and BOD, the CH is on time and the factor is on TIC as percentage'),
      Command(code: '249', sec: '1', tic: '38', description: 'Correlation factor between COD and TOC % expressed as 1/266'),
      Command(code: '250', sec: '250', tic: '0', description: 'Serial out different lines per each method'),
      Command(code: '251', sec: '251', tic: '0', description: 'Serial out (Tic = seconds interval)'),
      Command(code: '252', sec: '252', tic: '0', description: 'Stop serial out'),
      Command(code: '253', sec: '253', tic: '7', description: 'VK8 OFF, specific for WIZ'),
      Command(code: '258', sec: '5', tic: '4', description: 'Consente il mantenimento dell\'energia per permettere lo sviluppo a gradoni'),
      Command(code: '259', sec: '259', tic: '0', description: 'Esegue il reset del comando 258, è indispensabile per permettere lo sviluppo dei gradoni successivi'),
      Command(code: '266', sec: '1', tic: '0', description: 'open V1 valve (bistable command)'),
      Command(code: '267', sec: '1', tic: '0', description: 'close V1 valve'),
      Command(code: '266', sec: '1', tic: '1', description: 'open V2 valve (bistable command)'),
      Command(code: '267', sec: '1', tic: '1', description: 'close V2 valve'),
      Command(code: '266', sec: '1', tic: '2', description: 'open V3 valve (bistable command)'),
      Command(code: '267', sec: '1', tic: '2', description: 'close V3 multiple valve'),
      Command(code: '268', sec: '268', tic: '4', description: 'Minisampler command, at end of SEQ9'),
      Command(code: '269', sec: '269', tic: '4', description: 'Minisampler command, at beginning of SEQ9'),
      Command(code: '270', sec: '270', tic: '', description: 'CHECK UV LAMP'),
      Command(code: '271', sec: '271', tic: '', description: 'Pressure Start'),
      Command(code: '272', sec: '272', tic: '', description: 'Check Reag.Ing.'),
      Command(code: '273', sec: '273', tic: '', description: 'Check Vacuum+Pump'),
      Command(code: '276', sec: '276', tic: '', description: 'Check O.Press. ON'),
      Command(code: '277', sec: '277', tic: '', description: 'Check O.Press. OFF'),
      Command(code: '278', sec: '1000', tic: '1000', description: 'check for sample and reference minimum V, this case must be over 1 V'),
      Command(code: '279', sec: '1000', tic: '1000', description: 'check Ref/Smp (If low) su color 2'),
      Command(code: '280', sec: '4000', tic: '4000', description: 'check for sample and reference maximum V, this case must be below 4 V'),
      Command(code: '281', sec: '4000', tic: '4000', description: 'check Ref/Smp (If high) su color 2'),
      Command(code: '287', sec: '1', tic: '0', description: 'STOP power to heating bath HB1'),
      Command(code: '288', sec: '1', tic: '0', description: 'START power to heating bath HB1'),
      Command(code: '294', sec: '1', tic: 'x', description: 'dosing error code: TIC: 1200=R1,1300=R2,1400=R3'),
      Command(code: '295', sec: '3', tic: '4', description: 'set tolerances on arrival and duration of reagent at sensor #2 (this example ± 3" on arrival and ± 4" on dosing time)'),
      Command(code: '296', sec: '5', tic: '11', description: 'set arrival time and duration of reagent at sensor #2 (this example 5" for arrival and 11" for dosing time)'),
      Command(code: '298', sec: '298', tic: '', description: 'CHECKING FOR SAMPLE'),
      Command(code: '299', sec: '1', tic: '0', description: 'acid presence (from output 30D bit #3: if missing start WASH)'),
      Command(code: '300', sec: 'x', tic: 'y', description: 'Gosub (Time = cycle; Tic = step): cycle number and start step of subroutine'),
      Command(code: '301', sec: '1', tic: '0', description: 'Return from Gosub'),
      Command(code: '302', sec: '1', tic: 'X', description: 'Goto (Tic = step)'),
      Command(code: '305', sec: '1', tic: '0', description: 'CHECK for OD maximum allowed: TIC/100= max OD'),
      Command(code: '306', sec: '1', tic: '60', description: 'wait until temperature is below T set as TIC (this example below 60°C)'),
      Command(code: '307', sec: '1', tic: '75', description: 'wait until temperature is above T set as TIC (this example over 75°C)'),
      Command(code: '308', sec: '0', tic: '0', description: 'wait until the MINUTES of real time clock is equal to the set in second, used to start at same minute'),
      Command(code: '310', sec: '1', tic: '0', description: 'If temp lower than TIC then do next steps else jump of n. set as SEC steps'),
      Command(code: '311', sec: '1', tic: '0', description: 'sets the sequence 9 OFF, to be placed at beginning of cycles with sequence 9 activation at the end'),
      Command(code: '312', sec: '1', tic: '0', description: 'Sets the file WASH.DAT as active (=1) so that when powered off then on it starts with a wash cycle'),
      Command(code: '313', sec: '1', tic: '0', description: 'Set the file WASH.DAT as inactive (=0) so that when powered OFF then ON it sets back to monitor wothout wash cycle'),
      Command(code: '314', sec: 'x', tic: 'y', description: 'this command sets the slope and bias for temperature compensation, using the T2 as X in the equation Y=aX+b'),
      Command(code: '315', sec: '1', tic: '0', description: 'Sets TIME OUT Time in sec. For commands such as 306 or 307'),
      Command(code: '316', sec: '1', tic: '0', description: 'If temperature is over the setted, command waits until TIMEOUT finishes or until the T is below T set as TIC'),
      Command(code: '317', sec: '1', tic: '0', description: 'If temperature is lower the setted, command waits until TIMEOUT finishes or until the T is over T set as TIC'),
      Command(code: '318', sec: '1', tic: '0', description: 'if liquid check is within time set for 315, and then jumps of two steps ahead'),
      Command(code: '322', sec: 'x', tic: 'y', description: 'if temperature T1 is below Y, jump of X steps'),
      Command(code: '323', sec: 'x', tic: 'y', description: 'if temperature T2 is below Y, jump of X steps'),
      Command(code: '327', sec: 'temp', tic: 'fattore 1', description: 'if the temperature T2 of sensor 2 is equal or below the value set as Tlow in TIME of command 327, the result will be multiplied for the factor F1'),
      Command(code: '327', sec: 'temp', tic: 'fattore 1', description: 'if the temperature T2 of sensor 2 is equal or below the value set as Tlow in TIME of command 327, the result will be multiplied for the factor F1'),
      Command(code: '328', sec: 'temp', tic: 'fattore 2', description: 'if the temperature T2 of sensor 2 is equal or above the value set in Thigh in TIME of command 328, the result will be multiplied for the factor F2'),
      Command(code: '330', sec: '1', tic: '0', description: 'Start area measurement for TOC specific'),
      Command(code: '331', sec: '1', tic: '0', description: 'Stop area measurement for TOC specific'),
      Command(code: '332', sec: '1', tic: '0', description: 'Start Area mode for the cycle, normally TOC, correlation with area and concentration'),
      Command(code: '333', sec: '1', tic: '0', description: 'Stop area mode for the cycle, to set back normal analysis with colorimetry using OD'),
      Command(code: '334', sec: '1', tic: '0', description: 'Start Area reading (normally before 93 or 67)'),
      Command(code: '335', sec: '1', tic: '0', description: 'Stop Area reading (normally before 93 or 67)'),
      Command(code: '336', sec: '1', tic: '0', description: 'Check for linearity for dilution: not activated'),
      Command(code: '337', sec: '1', tic: '0', description: 'Set MODE AREA ON USED ON TOC AT CYCLE START'),
      Command(code: '338', sec: '1', tic: '0', description: 'Set MODE AREA OFF USED ON TOC AT CYCLE END set before 199'),
      Command(code: '340', sec: '1', tic: '0', description: 'Sets fluorimetric mode ON'),
      Command(code: '340', sec: '1', tic: '0', description: 'Read INPUT 0 for this method (normally ISE)'),
      Command(code: '341', sec: '0', tic: '0', description: 'reset input as set on original method'),
      Command(code: '342', sec: '1', tic: '0', description: 'Fluorimeter # 2 Active (for systems with two fluorimeters independent)'),
      Command(code: '343', sec: '1', tic: '0', description: 'Fluorimeter #1 Active'),
      Command(code: '345', sec: 'sec', tic: 'class', description: 'Class measurement for 93 and 67: time sets the reading, TIC sets the class amplitude'),
      Command(code: '346', sec: '100', tic: '2', description: 'Average reading of detection in seconds, used before 93 and 67 commands to get stable Ods'),
      Command(code: '352', sec: 'X', tic: '0', description: 'Pump reverse fast, Time is the activation time, it is stopped by 65'),
      Command(code: '354', sec: '1', tic: 'X', description: 'Go sub for another method that is set in TIC 0,1,2 or 3'),
      Command(code: '355', sec: 'X', tic: 'Y', description: 'Go sub for another method to go to Cycle X and Step Y'),
      Command(code: '356', sec: '1', tic: '0', description: 'Return from Go sub 354 and 355'),
      Command(code: '357', sec: '1', tic: '0', description: 'Command to go to Dilution with UV TN and NO3 methods'),
      Command(code: '360', sec: '1', tic: '0', description: '4-20 mA output: this command set all outputs on the same 4-20 mA output'),
      Command(code: '366', sec: '1', tic: '0', description: 'Temperature of HB1 to T mant.'),
      Command(code: '371', sec: '1', tic: '0', description: 'STOP TIMER REAL TIME DATA OUT SERIAL PORT'),
      Command(code: '373', sec: '1', tic: '0', description: 'USED FOR NEW EPA (CN2011) PROTOCOL WITH NEW CRC CALC.'),
      Command(code: '380', sec: '1', tic: '4', description: 'set tolerance on temperature hysteresys'),
      Command(code: '381', sec: '1', tic: '0', description: 'Reset temperature hysteresys at 3°C tolerance (normal MMAC setting)'),
      Command(code: '400', sec: '', tic: '', description: 'IF cleaning, THEN'),
      Command(code: '401', sec: '1', tic: 'X', description: 'Timeout check, if overtaken will give out timeout error'),
      Command(code: '402', sec: '1', tic: '0', description: 'Timeout reset counter'),
      Command(code: '420', sec: 'X', tic: 'Y', description: 'These commands can have X or Y from 1 to 10, and refer to the TS list of timings'),
      Command(code: '430', sec: '1', tic: 'x', description: 'Starts the SAC 254 mode: Tic = 1 ON ; Tic = 0 OFF)'),
      Command(code: '431', sec: '1', tic: 'x', description: 'Start OD for SAC MODE: Tic = 1 254 nm; Tic = 0 550 nm'),
      Command(code: '432', sec: '1', tic: 'x', description: 'End OD for SAC MODE: Tic = 1 254 nm; Tic = 0 550 nm'),
      Command(code: '433', sec: '1', tic: '0', description: 'Calculation final OD SAC254 method: OD 254-OD 550'),
      Command(code: '440', sec: 'max', tic: 'min', description: 'Random value to be generated when below min/10'),
      Command(code: '441', sec: '1', tic: '0', description: 'Option not to calculate the results on the Micromac'),
      Command(code: '442', sec: 'max', tic: 'min', description: 'Random value to be generated when below min/100'),
      Command(code: '444', sec: 'max', tic: 'min', description: 'Random value to be generated when below min/1000'),
      Command(code: '446', sec: '1', tic: 'X', description: 'Flow sensor for TOC'),
      Command(code: '449', sec: '1', tic: '1', description: 'Activates MODE NO3UV - TN UV'),
      Command(code: '450', sec: 'X', tic: 'Y', description: 'X = RIP,Y = FLASH reads start energy for 220 and 275 nm'),
      Command(code: '451', sec: 'X', tic: 'Y', description: 'X = RIP,Y = FLASH reads final energy for 220 and 275 nm'),
      Command(code: '452', sec: '1', tic: '0', description: 'OD at 220nm and OD at 275nm calculation'),
      Command(code: '453', sec: '1', tic: '0', description: 'OD 220 - 2*OD 274 calculation (ISO method)'),
      Command(code: '454', sec: '1', tic: '0', description: 'ODuv=log10(REF254/SMP254)-(X/10)log10(REF880/SMP880)'),
      Command(code: '455', sec: '1', tic: 'x', description: 'Comando per LED pulsato 880, Calcola REF880'),
      Command(code: '455', sec: '2', tic: 'x', description: 'Comando per LED pulsato 880, Calcola SMP880'),
      Command(code: '456', sec: '1', tic: 'X', description: 'Comando per LED 370 con accumulo'),
      Command(code: '457', sec: '1', tic: '0', description: 'BOD flashes reset'),
      Command(code: '458', sec: '1', tic: 'dark', description: 'factor for OD correction and dark current value subtraction'),
      Command(code: '459', sec: '1', tic: 'X', description: 'Set factor for subtraction OD 525 from OD 254 for COD new version June 2019'),
      Command(code: '461', sec: '1', tic: 'X', description: 'Comando per led pulsato 254, Calcola REF254'),
      Command(code: '461', sec: '2', tic: 'X', description: 'Comando per led pulsato 254, Calcola SMP254'),
      Command(code: '463', sec: '1', tic: '0', description: 'Check for range'),
      Command(code: '464', sec: '1', tic: '0', description: 'Check for dilution'),
      Command(code: '465', sec: '1', tic: '0', description: 'Go to normal range'),
      Command(code: '480', sec: '1', tic: '0', description: 'Serial output ON'),
      Command(code: '490', sec: '1', tic: '0', description: 'Calibrant high for TN multiple when running polinomial on one cycle'),
      Command(code: '491', sec: '1', tic: '0', description: 'Calibrant low 50% for TN multiple when running polinomial on one cycle'),
      Command(code: '500', sec: '1', tic: '0', description: 'Liquid check, COD WTW'),
      Command(code: '505', sec: '1', tic: '0', description: 'Activate the result storage on CICLO5 to abilitate its result to be memorized'),
      Command(code: '509', sec: '', tic: '', description: 'Handshake with syringe'),
      Command(code: '510', sec: '', tic: '', description: 'Home position ofr Syringe with stepper motors'),
      Command(code: '511', sec: '', tic: '', description: 'Aspiration time of syringe, in TIC number of steps'),
      Command(code: '512', sec: '', tic: '', description: 'Dosing time of syringe, in TIC number of steps'),
      Command(code: '513', sec: '', tic: '', description: 'Set on tic the flowrate of syringe'),
      Command(code: '514', sec: '', tic: '', description: 'Set the titration mode on, TIC=1 is on, TIC=0 is off'),
      Command(code: '515', sec: '', tic: '', description: 'reset counter for volume dosed'),
      Command(code: '516', sec: '', tic: '', description: 'count the dosing until the TIC is reached as mV of change'),
      Command(code: '536', sec: '1', tic: 'X', description: 'K8 ON for TIC'),
      Command(code: '541', sec: '1', tic: 'X', description: 'Su scheda nuova invia il risultato alla 4-20 mA. X=1 meth0; 2 meth1 etc.'),
      Command(code: '551', sec: 'x', tic: 'y', description: 'Activation LED for TIC milliseconds for 100'),
      Command(code: '554', sec: '1', tic: 'X', description: 'Swap energies on COD to save values correctly energy start 254 on result buffer'),
      Command(code: '558', sec: '1', tic: 'dark', description: 'Value on TIC as % of energy at 220 nm'),
      Command(code: '560', sec: 'X', tic: '0', description: 'read the channel to be converted X 1 or 6 or 7'),
      Command(code: '570', sec: '1', tic: '0', description: 'POMPA 1 STOP'),
      Command(code: '570', sec: '1', tic: '1', description: 'POMPA 1 DIRECT FAST'),
      Command(code: '570', sec: '1', tic: '2', description: 'POMPA 1 REVERSE FAST'),
      Command(code: '570', sec: '1', tic: '3', description: 'POMPA 1 DIRECT SLOW'),
      Command(code: '570', sec: '1', tic: '4', description: 'POMPA 1 REVERSE SLOW'),
      Command(code: '571', sec: '1', tic: '0', description: 'POMPA 2 STOP'),
      Command(code: '571', sec: '1', tic: '1', description: 'POMPA 2 DIRECT FAST'),
      Command(code: '571', sec: '1', tic: '2', description: 'POMPA 2 REVERSE FAST'),
      Command(code: '571', sec: '1', tic: '3', description: 'POMPA 2 DIRECT SLOW'),
      Command(code: '571', sec: '1', tic: '4', description: 'POMPA 2 REVERSE SLOW'),
      Command(code: '572', sec: 'X', tic: 'Y', description: 'Pump 3 on new board: X=activation time in seconds; Y: 0=stop; 1= dir; 2= rev; 3= dir slow; 4= rev slow'),
      // Aggiungi altri comandi dal tuo file
    ]);
  }

  void _filterCommands(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCommands = List.from(commands);
      } else {
        filteredCommands = commands.where((command) {
          if (searchType == 'code') {
            return command.code.toLowerCase().contains(query.toLowerCase());
          } else {
            return command.description.toLowerCase().contains(query.toLowerCase());
          }
        }).toList();
      }
    });
  }

  void _addCommand() {
    String code = '';
    String sec = '';
    String tic = '';
    String description = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aggiungi Comando'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Codice',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => code = value,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'SEC',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => sec = value,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'TIC',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => tic = value,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Descrizione',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => description = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  commands.add(Command(
                    code: code,
                    sec: sec,
                    tic: tic,
                    description: description,
                  ));
                  filteredCommands = List.from(commands);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Salva'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCommand(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conferma eliminazione'),
          content: const Text('Sei sicuro di voler eliminare questo comando?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  commands.removeAt(index);
                  filteredCommands = List.from(commands);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Elimina'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista dei Comandi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCommand,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Cerca',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _filterCommands,
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: searchType,
                  items: const [
                    DropdownMenuItem(value: 'code', child: Text('Codice')),
                    DropdownMenuItem(value: 'description', child: Text('Descrizione')),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        searchType = value;
                        _filterCommands(searchController.text);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCommands.length,
              itemBuilder: (context, index) {
                final command = filteredCommands[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text('${command.code} - ${command.description}'),
                    subtitle: Text('SEC: ${command.sec}, TIC: ${command.tic}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteCommand(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
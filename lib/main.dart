import 'package:flutter/material.dart';
import 'cicli.dart';
import 'lista_dei_comandi.dart';
import 'codici_pezzi.dart';
import 'convertire_risultati.dart';
import 'diluizioni.dart';
import 'calcolo_risultati.dart';
import 'accuratezza_linearita.dart';  // Modificato questo import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SysTools',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget Function(BuildContext)> pageRoutes = {
      'Cicli': (context) => const CicliPage(),
      'Convertire risultati': (context) => const ConvertireRisultatiPage(),
      'Diluizioni': (context) => const DiluizioniPage(),
      'Linearità e accuratezza': (context) => const AccuratezzaLinearita(), // Modificata questa riga
      'Calcolo risultati': (context) => const CalcoloRisultatiPage(),
      'Lista dei comandi': (context) => const ListaDeiComandi(),
      'Codici pezzi': (context) => const CodiciPezziPage(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('SysTools'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: pageRoutes.length,
          itemBuilder: (context, index) {
            String pageName = pageRoutes.keys.elementAt(index);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: pageRoutes[pageName]!,
                    ),
                  );
                },
                child: Text(
                  pageName,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
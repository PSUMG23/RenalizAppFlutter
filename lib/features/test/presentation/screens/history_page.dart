import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:renalizapp/features/shared/infrastructure/provider/auth_provider.dart';
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  final GoRouter appRouter;

  HistoryPage({required this.appRouter});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> history = [];

  // Carga el historial desde SharedPreferences
 Future<void> loadHistory() async {
  final authProvider = context.read<AuthProvider>();
  String? uid = authProvider.currentUser?.uid;
  print(uid);

  if (uid != null) {
    print("Se ha iniciado sesion");
    // Usuario ha iniciado sesión
    final response = await http.post(
      Uri.parse('https://us-central1-renalizapp-dev-2023-396503.cloudfunctions.net/renalizapp-2023-dev-getTestsByUid'),
      body: json.encode({'uid': uid}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String formattedResult = data['formattedResult'];
      print(formattedResult);

      // Dividir formattedResult en una lista de cadenas
      final List<String> historyItems = formattedResult.split(', ');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('history', historyItems);

      setState(() {
        history = historyItems;
      });
      print(prefs);
    } else {
      // Manejar error en la respuesta
    }
  } else {
    print("NO se ha iniciado sesion");
    // Usuario no ha iniciado sesión
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedHistory = prefs.getStringList('history');
    if (savedHistory != null) {
      setState(() {
        history = savedHistory;
      });
    }
  }
}


  @override
  void initState() {
    super.initState();
    loadHistory(); // Carga el historial cuando se inicia la página
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historial de Puntuaciones"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icono de flecha hacia atrás
          onPressed: () {
            // Navega de regreso a la pantalla anterior
            widget.appRouter.pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          // Divide la cadena almacenada en SharedPreferences
          final data = history[index].split(';');
          if (data.length == 4) {
            final score = data[0];
            final resultMessage = data[1];
            final resultDescription = data[2];
            final testDate = data[3];

            return Card(
              elevation: 3, // Sombra ligera
              margin: EdgeInsets.all(8), // Margen alrededor de cada tarjeta
              child: ListTile(
                title: Text(
                  "Puntuación: $score",
                  style: TextStyle(
                    fontSize: 16, // Tamaño de fuente personalizado
                    fontWeight: FontWeight.bold, // Tipo de letra en negrita
                    // Cambia el tipo de letra aquí (usa una fuente personalizada o una predeterminada)
                    fontFamily: 'Roboto', // Cambia esto según tus preferencias
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Resultado: $resultMessage",
                      style: TextStyle(
                        fontSize: 14, // Tamaño de fuente personalizado
                        // Cambia el tipo de letra aquí (usa una fuente personalizada o una predeterminada)
                        fontFamily:
                            'Roboto', // Cambia esto según tus preferencias
                      ),
                    ),
                    Text(
                      "Descripción: $resultDescription",
                      style: TextStyle(
                        fontSize: 14, // Tamaño de fuente personalizado
                        // Cambia el tipo de letra aquí (usa una fuente personalizada o una predeterminada)
                        fontFamily:
                            'Roboto', // Cambia esto según tus preferencias
                      ),
                    ),
                    Text(
                      "Fecha de la prueba: $testDate",
                      style: TextStyle(
                        fontSize: 14, // Tamaño de fuente personalizado
                        // Cambia el tipo de letra aquí (usa una fuente personalizada o una predeterminada)
                        fontFamily:
                            'Roboto', // Cambia esto según tus preferencias
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container(); // Opcional: Manejar datos incorrectos
        },
      ),
    );
  }
}
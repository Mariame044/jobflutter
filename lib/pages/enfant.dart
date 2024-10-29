import 'package:flutter/material.dart';
import 'package:jobaventure/Service/enfant.dart';


class ProgressionPage extends StatefulWidget {
  final EnfantService enfantService;

  const ProgressionPage({Key? key, required this.enfantService}) : super(key: key);

  @override
  _ProgressionPageState createState() => _ProgressionPageState();
}

class _ProgressionPageState extends State<ProgressionPage> {
  late Future<Map<String, dynamic>> futureProgression;

  @override
  void initState() {
    super.initState();
    // Appeler l'API pour récupérer la progression de l'enfant connecté
    futureProgression = widget.enfantService.getProgression();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progression de l\'enfant'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureProgression,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Aucune donnée disponible.'));
          }

          final progression = snapshot.data!;
          
          // Affichage des détails de la progression
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nom : ${progression['nom'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Score : ${progression['score'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Niveau : ${progression['niveau'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                // Afficher d'autres informations de progression ici
              ],
            ),
          );
        },
      ),
    );
  }
}

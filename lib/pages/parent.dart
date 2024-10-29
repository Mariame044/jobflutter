import 'package:flutter/material.dart';
import 'package:jobaventure/Service/parent.dart';
import '../models/enfant.dart';

class EnfantSupervisionPage extends StatefulWidget {
  @override
  _EnfantSupervisionPageState createState() => _EnfantSupervisionPageState();
}

class _EnfantSupervisionPageState extends State<EnfantSupervisionPage> {
  final ApiService apiService = ApiService();
  late Future<List<Enfant>> enfantsFuture;
  final TextEditingController enfantEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    enfantsFuture = apiService.getEnfantsByCurrentParent();
  }

  Future<void> superviseEnfant(String enfantEmail) async {
    try {
      await apiService.superviseEnfant(enfantEmail);
      setState(() {
        enfantsFuture = apiService.getEnfantsByCurrentParent();
      });
      _showSnackBar('Enfant supervisé avec succès');
    } catch (e) {
      _showSnackBar('Erreur : $e');
    }
  }

  Future<void> showProgression(String enfantEmail) async {
    try {
      final progression = await apiService.getProgressionEnfant(enfantEmail);
      _showProgressionDialog(progression);
    } catch (e) {
      _showSnackBar('Erreur : $e');
    }
  }

  void _showProgressionDialog(Map<String, dynamic> progression) {
    String badges = progression['badges'].isNotEmpty ? progression['badges'].join(', ') : 'Aucun badge';
    String score = progression['score'].toString();
    String questionsResolues = progression['questionsResolues'].toString();
    String videos = progression['videos'].isNotEmpty ? progression['videos'].map((v) => v['description']).join(', ') : 'Aucune vidéo';
    String interviews = progression['interviews'].isNotEmpty ? progression['interviews'].map((i) => i['description']).join(', ') : 'Aucune interview';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Progression de l\'Enfant', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Score : $score', style: TextStyle(fontSize: 16)),
                Text('Questions Résolues : $questionsResolues', style: TextStyle(fontSize: 16)),
                Text('Badges : $badges', style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text('Vidéos :', style: TextStyle(fontWeight: FontWeight.bold)),
                for (var video in progression['videos']) 
                  Text(' - ${video['description'] ?? 'Sans description'}', style: TextStyle(fontSize: 14)),
                SizedBox(height: 10),
                Text('Interviews :', style: TextStyle(fontWeight: FontWeight.bold)),
                for (var interview in progression['interviews']) 
                  Text(' - ${interview['description'] ?? 'Sans description'}', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Fermer', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de Bord des Enfants'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: enfantEmailController,
              decoration: InputDecoration(
                labelText: 'Email de l\'Enfant à superviser',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                String enfantEmail = enfantEmailController.text.trim();
                if (enfantEmail.isNotEmpty) {
                  superviseEnfant(enfantEmail);
                } else {
                  _showSnackBar('Veuillez entrer un email valide.');
                }
              },
              icon: Icon(Icons.add, size: 18),
              label: Text('Superviser Enfant'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Enfant>>(
                future: enfantsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur : ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucun enfant supervisé.'));
                  } else {
                    final enfants = snapshot.data!;
                    return ListView.builder(
                      itemCount: enfants.length,
                      itemBuilder: (context, index) {
                        final enfant = enfants[index];
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  enfant.nom,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text('ID: ${enfant.id}', style: TextStyle(color: Colors.grey[600])),
                                SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    showProgression(enfant.email); // Appel de la méthode pour afficher la progression
                                  },
                                  child: Text('Voir Progression'),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

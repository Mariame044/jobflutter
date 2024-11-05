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
    futureProgression = widget.enfantService.getProgression();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Progression de l\'enfant',
          style: TextStyle(
            fontFamily: 'Comic Sans MS',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 5,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureProgression,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Aucune donnée disponible.'));
          }

          final progression = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue.shade100, Colors.green.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nom : ${progression['nom'] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildScoreRow(progression['score']),
                        SizedBox(height: 12),
                        _buildQuestionsResolvedRow(progression['questionsResolues']),
                        SizedBox(height: 12),
                        _buildLevelRow(progression['niveau']),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreRow(dynamic score) {
    return Row(
      children: [
        Icon(Icons.score, color: Colors.amber, size: 40),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            'Score : ${score ?? 'N/A'}',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsResolvedRow(List<dynamic>? questionsResolues) {
    return Row(
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 40),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            'Questions Résolues : ${questionsResolues?.length ?? 0}',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelRow(dynamic niveau) {
    return Row(
      children: [
        Icon(Icons.grade, color: Colors.blue, size: 40),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            'Niveau : ${niveau ?? 'N/A'}',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

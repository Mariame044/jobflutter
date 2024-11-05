import 'package:flutter/material.dart';
import 'package:jobaventure/Service/interview.dart';
import 'package:jobaventure/pages/question.dart';
import 'package:jobaventure/pages/videoplayer.dart';
import '../models/interview.dart';

class InterviewDetailPage extends StatelessWidget {
  final int interviewId;
  final InterviewService interviewService;

  const InterviewDetailPage({
    Key? key,
    required this.interviewId,
    required this.interviewService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Interview?>(
      future: interviewService.getInterviewById(interviewId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Chargement...'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Erreur'),
            ),
            body: Center(child: Text('Erreur: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Interview non trouvée'),
            ),
            body: const Center(child: Text('Aucune interview trouvée')),
          );
        }

        final interview = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share, color: Colors.blue),
                onPressed: () {
                  // Action pour partager
                },
              ),
            ],
            title: Text(
              interview.description ?? 'Détails de l\'Interview',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vidéo
                Container(
                  height: 200,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: interview.url != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: VideoPlayerWidget(
                            videoUrl: 'http://localhost:8080/' + interview.url!,
                          ),
                        )
                      : Center(child: Text('Aucune vidéo disponible')),
                ),
                const SizedBox(height: 16),

                // Titre
                Text(
                  'Interview de ${interview.admin?.nom ?? 'un professionnel'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.blueGrey[800],
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 8, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        interview.description ?? 'Pas de description disponible',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Date de publication
                Text(
                  'Date de publication: ${interview.date ?? 'Pas de date disponible'}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),

                // Bouton Poser une Question
                Center(
                  child: _buildAnimatedButton(
                    context: context,
                    label: 'Poser une question',
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () async {
                      await _handlePoserQuestionButton(context, interview.id);
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Interviews',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.question_answer),
                label: 'Questions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'Info',
              ),
            ],
            currentIndex: 1,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            onTap: (index) {
              // Logique de navigation
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/home');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/interviews');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/questions');
                  break;
                case 3:
                  Navigator.pushNamed(context, '/info');
                  break;
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildAnimatedButton({
    required BuildContext context,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }

  Future<void> _handlePoserQuestionButton(BuildContext context, int interviewId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PoserQuestionPage(
          interviewId: interviewId,
          interviewService: interviewService,
        ),
      ),
    );
  }
}

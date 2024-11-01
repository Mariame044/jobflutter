import 'package:flutter/material.dart';
import 'package:jobaventure/Service/interview.dart';
import 'package:jobaventure/Service/video.dart';
import 'package:jobaventure/pages/question.dart';
import 'package:jobaventure/pages/videoplayer.dart'; // Assurez-vous d'importer correctement votre widget
import '../models/interview.dart'; // Importer votre modèle d'interview
// Assurez-vous d'importer la page pour poser une question

class InterviewDetailPage extends StatelessWidget {
  final int interviewId;
  final InterviewService interviewService; // Service pour récupérer les vidéos

  const InterviewDetailPage({
    Key? key,
    required this.interviewId,
    required this.interviewService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Interview?>(
      future: interviewService.getInterviewById(interviewId), // Appeler le service pour obtenir l'interview
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Chargement...'),
            ),
            body: const Center(child: CircularProgressIndicator()), // Afficher un indicateur de chargement
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Erreur'),
            ),
            body: Center(child: Text('Erreur: ${snapshot.error}')), // Gérer les erreurs
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Interview non trouvée'),
            ),
            body: const Center(child: Text('Aucune interview trouvée')), // Aucun résultat trouvé
          );
        }

        final interview = snapshot.data!; // Récupérer les données de l'interview

        return Scaffold(
          appBar: AppBar(
            title: Text(interview.description ?? 'Détails de l\'Interview'), // Titre par défaut
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche pour une meilleure présentation
            children: [
              Container(
                height: 300, // Ajustez la hauteur selon vos besoins
                width: double.infinity,
                child: interview.url != null
                    ? VideoPlayerWidget(videoUrl: 'http://localhost:8080/' + interview.url!)
                    : const Center(child: Text('Aucune vidéo disponible')),
              ),
              const SizedBox(height: 16), // Espace entre la vidéo et le texte
              Padding(
                padding: const EdgeInsets.all(16.0), // Espacement intérieur
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description: ${interview.description ?? 'Pas de description disponible'}'),
                    const SizedBox(height: 8), // Espace entre les éléments
                    Text('Date de publication: ${interview.date ?? 'Pas de date disponible'}'),
                    const SizedBox(height: 8), // Espace entre les éléments
                    Text('Métier: ${interview.metier?.nom ?? 'Métier inconnu'}'), // Affichage du métier
                    const SizedBox(height: 16), // Espace supplémentaire avant le bouton
                    // Bouton pour poser une question
                    _buildAnimatedButton(
                      context: context,
                      label: 'Poser une question',
                      color: Colors.blue, // Couleur pour le bouton de question
                      textColor: Colors.white,
                      onPressed: () async {
                        await _handlePoserQuestionButton(context, interview.id); // Passer l'ID de l'interview
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Méthode pour créer un bouton animé
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
          borderRadius: BorderRadius.circular(12.0), // Coins arrondis
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 16, color: textColor),
      ),
    );
  }

  // Méthode pour gérer le bouton "Poser une question"
  Future<void> _handlePoserQuestionButton(BuildContext context, int interviewId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PoserQuestionPage(
          interviewId: interviewId,
          interviewService: interviewService, // Passez le service d'interview
        ),
      ),
    );
  }
}

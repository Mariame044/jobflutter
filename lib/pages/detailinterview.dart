import 'package:flutter/material.dart';
import 'package:jobaventure/Service/interview.dart';
import 'package:jobaventure/Service/video.dart';
import 'package:jobaventure/pages/videoplayer.dart'; // Assurez-vous d'importer correctement votre widget
import '../models/interview.dart'; // Importer votre modèle d'interview

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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jobaventure/Service/video.dart'; // Assurez-vous que le chemin est correct
import 'package:jobaventure/pages/videoplayer.dart';
import '../models/video.dart';
// Assurez-vous que vous avez un widget vidéo pour afficher la vidéo

class VideoDetailScreen extends StatelessWidget {
  final int videoId; // ID de la vidéo à afficher
  final VideoService videoService; // Service pour récupérer les vidéos

  const VideoDetailScreen({Key? key, required this.videoId, required this.videoService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Video?>(
      future: videoService.getVideoById(videoId), // Appeler le service pour obtenir la vidéo
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Afficher un indicateur de chargement
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}')); // Gérer les erreurs
        } else if (!snapshot.hasData) {
          return Center(child: Text('Aucune vidéo trouvée')); // Aucun résultat trouvé
        }

        final video = snapshot.data!; // Récupérer les données de la vidéo

        return Scaffold(
          appBar: AppBar(
            title: Text('Détails de la Vidéo'), // Titre de l'écran
          ),
          body: Column(
            children: [
              Container(
                height: 300, // Ajustez la hauteur selon vos besoins
                width: double.infinity,
                child: VideoPlayerWidget(videoUrl: video.url != null ? 'http://localhost:8080/' + video.url! : ''), // Widget pour jouer la vidéo
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Description: ${video.description ?? 'Inconnue'}'), // Afficher la description de la vidéo
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Retourner à l'écran précédent
                },
                child: Text('Retour'), // Bouton de retour
              ),
            ],
          ),
        );
      },
    );
  }
}

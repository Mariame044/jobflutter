import 'package:flutter/material.dart';
import 'package:jobaventure/Service/video.dart'; // Assurez-vous que le chemin est correct
import 'package:jobaventure/pages/videoplayer.dart';
import '../models/video.dart';
import 'package:share_plus/share_plus.dart'; // Importation pour la fonctionnalité de partage

class VideoDetailScreen extends StatelessWidget {
  final int videoId; // ID de la vidéo à afficher
  final VideoService videoService; // Service pour récupérer les vidéos

  const VideoDetailScreen({
    Key? key,
    required this.videoId,
    required this.videoService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Video?>(
      future: videoService.getVideoById(videoId), // Appeler le service pour obtenir la vidéo
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Afficher un indicateur de chargement
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erreur: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          ); // Gérer les erreurs
        } else if (!snapshot.hasData) {
          return Center(
            child: Text(
              'Aucune vidéo trouvée',
              style: TextStyle(fontSize: 18),
            ),
          ); // Aucun résultat trouvé
        }

        final video = snapshot.data!; // Récupérer les données de la vidéo

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Détails de la Vidéo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context), // Retourner à l'écran précédent
            ),
          ),
          body: ListView( // Utiliser ListView pour gérer le défilement
            padding: const EdgeInsets.all(16.0),
            children: [
              Container(
                 // Ajustez la hauteur selon vos besoins
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: VideoPlayerWidget(
                    videoUrl: video.url != null ? 'http://localhost:8080/' + video.url! : '',
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Description:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                video.description ?? 'Inconnue',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 16),
              
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () {
                  // Logique pour partager la vidéo
                  String shareContent = "Regardez cette vidéo: ${video.url != null ? 'http://localhost:8080/' + video.url! : ''}";
                  Share.share(shareContent, subject: 'Partage de vidéo'); // Utilisation du package share_plus
                },
                icon: Icon(Icons.share),
                label: Text('Partager'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF036A94), // Couleur du texte
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

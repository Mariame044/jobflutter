import 'package:flutter/material.dart';
import 'package:jobaventure/pages/videoplayer.dart';
// Assurez-vous d'importer correctement votre widget
import '../models/video.dart';

class VideoDetailScreen extends StatelessWidget {
  final Video video;

  const VideoDetailScreen({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(video.description ?? 'Vidéo'),
      ),
      body: Column(
        children: [
          Container(
            height: 300, // Ajustez la hauteur selon vos besoins
            width: double.infinity,
            child: video.url != null
                ? VideoPlayerWidget(videoUrl: 'http://localhost:8080/' + video.url!)
                : Center(child: Text('Aucune vidéo disponible')),
          ),
          SizedBox(height: 16),
          Text('Durée: ${video.duree ?? 'Inconnue'}'), // Utilisez 'Inconnue' si duree est null
        ],
      ),
    );
  }
}

// lib/video_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:jobaventure/pages/videoplayer.dart';
import '../models/video.dart';

class VideoDetailScreen extends StatelessWidget {
  final Video video;

  const VideoDetailScreen({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(video.description), // Utiliser la description de la vidéo comme titre
      ),
      body: Column(
        children: [
          // Widget pour le lecteur vidéo (utilisez un package de lecteur vidéo pour la lecture réelle)
          Container(
            height: 200,
            width: double.infinity,
            child: video.url != null
                ? VideoPlayerWidget(videoUrl: 'http://localhost:8080/' + video.url!) // Utilisez un widget de lecteur vidéo
                : Center(child: Text('Aucune vidéo disponible')),
          ),
          SizedBox(height: 16),
          Text('Durée: ${video.duree}'),
        ],
      ),
    );
  }
}

// Vous aurez également besoin d'un VideoPlayerWidget pour gérer la lecture de la vidéo
// Importez des packages de lecteur vidéo comme video_player pour cette fonctionnalité

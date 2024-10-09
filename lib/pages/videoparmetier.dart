import 'package:flutter/material.dart';
import 'package:jobaventure/models/video.dart';
import 'package:jobaventure/pages/detailvideo.dart';
// N'oubliez pas d'importer la page de détails de la vidéo

class GroupedVideosScreen extends StatelessWidget {
  final List<Video>? videos; // Liste de vidéos pour un métier

  const GroupedVideosScreen({Key? key, this.videos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vidéos pour ce métier'),
      ),
      body: videos == null || videos!.isEmpty
          ? Center(child: Text('Aucune vidéo disponible pour ce métier'))
          : ListView.builder(
              itemCount: videos!.length,
              itemBuilder: (context, index) {
                Video video = videos![index];
                return Card(
                  margin: EdgeInsets.all(8.0), // Marge autour de chaque carte
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Espacement à l'intérieur de la carte
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre de la vidéo

                        SizedBox(height: 8.0), // Espacement entre le titre et la description
                        // Description de la vidéo
                        Text(
                          video.description ?? 'Aucune description',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8.0), // Espacement sous la description
                        // Ajouter un bouton ou un lien pour voir la vidéo
                        ElevatedButton(
                          onPressed: () {
                            // Naviguer vers l'écran de détail vidéo
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoDetailScreen(video: video),
                              ),
                            );
                          },
                          child: Text('Voir la vidéo'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

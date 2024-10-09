import 'package:flutter/material.dart';
import 'package:jobaventure/Service/video.dart';
import 'package:jobaventure/models/categorie.dart';
import 'package:jobaventure/models/video.dart';
import 'package:jobaventure/pages/videoparmetier.dart';
 // Importez la page de détails de métier

class DetailMetier extends StatelessWidget {
  final Metier metier; // Instance du métier
  final VideoService videoService; // Instance du service vidéo

  const DetailMetier({
    Key? key,
    required this.metier,
    required this.videoService, // Assurez-vous que ce paramètre est requis
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(metier.nom),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section des boutons
            Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        // Naviguer vers l'écran des vidéos pour ce métier
                        List<Video>? videos = await videoService.getVideosByMetierId(metier.id);
                        if (videos != null && videos.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupedVideosScreen(videos: videos),
                            ),
                          );
                        } else {
                          // Afficher un message si aucune vidéo n'est trouvée
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Aucune vidéo disponible pour ce métier.')),
                          );
                        }
                      } catch (e) {
                        // Gestion des erreurs lors de la récupération des vidéos
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erreur lors de la récupération des vidéos: $e')),
                        );
                      }
                    },
                    child: Text('Vidéo'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                     
                    },
                    child: Text('Métier'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Jeu de rôle button press
                    },
                    child: Text('Jeu de rôle'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Interviews button press
                    },
                    child: Text('Interviews'),
                  ),
                ],
              ),
            ),
            // Afficher l'image du métier
            metier.imageUrl != null
                ? Image.network(
                    'http://localhost:8080/' + metier.imageUrl!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 200,
                    color: Colors.grey,
                    child: Center(child: Text('Aucune image disponible')),
                  ),
            SizedBox(height: 16),
            // Nom du métier
            Text(
              metier.nom,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Description du métier
            Text(
              metier.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            // Catégorie du métier
            if (metier.categorie != null) 
              Text(
                'Catégorie: ${metier.categorie!.nom}',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }
}

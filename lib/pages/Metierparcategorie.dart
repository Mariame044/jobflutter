import 'package:flutter/material.dart';
import 'package:jobaventure/Service/video.dart'; // Importation du service vidéo
import 'package:jobaventure/models/categorie.dart'; // Importation du modèle de catégorie
import 'detailsmetier.dart'; // Importation de la page de détails du métier

class MetierCategoryPage extends StatelessWidget {
  final String categoryName; // Nom de la catégorie
  final List<Metier> metiers; // Liste des métiers
  final VideoService videoService; // Service vidéo

  // Constructeur avec paramètres requis
  MetierCategoryPage({
    required this.categoryName,
    required this.metiers,
    required this.videoService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName), // Titre de la barre d'application
      ),
      body: Column(
        children: [
          // Grille de métiers
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Nombre de cartes par ligne
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.8, // Ratio d'aspect pour l'apparence
              ),
              padding: EdgeInsets.all(8.0),
              itemCount: metiers.length, // Nombre total d'éléments dans la liste
              itemBuilder: (context, index) {
                Metier metier = metiers[index]; // Récupération du métier
                return GestureDetector(
                  onTap: () {
                    // Navigation vers la page de détails du métier
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailMetier(
                          metier: metier,
                          videoService: videoService, // Passez l'instance de videoService ici
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        Expanded(
                          child: metier.imageUrl != null
                              ? Image.network(
                                  'http://localhost:8080/' + metier.imageUrl!,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey,
                                  child: Center(child: Text('Aucune image')),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            metier.nom, // Nom du métier
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            metier.description, // Description du métier
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jobaventure/Service/interview.dart';
import 'package:jobaventure/Service/jeu.dart';
import 'package:jobaventure/Service/metier_service.dart';
import 'package:jobaventure/Service/video.dart'; // Importation du service vidéo
import 'package:jobaventure/models/categorie.dart'; // Importation du modèle de catégorie
import 'detailsmetier.dart'; // Importation de la page de détails du métier

class MetierCategoryPage extends StatelessWidget {
  final String categoryName; // Nom de la catégorie
  final List<Metier> metiers; // Liste des métiers
  final VideoService videoService; // Service vidéo
  final InterviewService interviewService; // Service interview
  final JeuderoleService jeuderoleService;
  final MetierService metierService;

  // Constructeur avec paramètres requis
  MetierCategoryPage({
    required this.categoryName,
    required this.metiers,
    required this.jeuderoleService,
    required this.interviewService,
    required this.videoService,
    required this.metierService,
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
                crossAxisSpacing: 8.0, // Espacement horizontal
                mainAxisSpacing: 8.0, // Espacement vertical
                childAspectRatio: 0.75, // Ajustement du ratio pour rendre les cartes plus longues
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
                          interviewService: interviewService,
                          videoService: videoService,
                          jeuderoleService: jeuderoleService, metierService: metierService,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Bords arrondis des cartes
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: metier.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0),
                                  ), // Bords arrondis en haut de l'image
                                  child: Image.network(
                                    'http://localhost:8080/' + metier.imageUrl!,
                                    fit: BoxFit.cover, // Image qui prend toute la largeur
                                  ),
                                )
                              : Container(
                                  color: Colors.grey,
                                  child: Center(child: Text('Aucune image')),
                                ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Colors.grey.shade200, // Fond sous l'image
                          child: Column(
                            children: [
                              Text(
                                metier.nom, // Nom du métier
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4.0), // Espace entre le nom et la description
                              Text(
                                metier.description, // Description du métier
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis, // Texte coupé si trop long
                                style: TextStyle(fontSize: 14.0, color: Colors.black54),
                                textAlign: TextAlign.center,
                              ),
                            ],
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

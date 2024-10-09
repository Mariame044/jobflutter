import 'package:flutter/material.dart';
import 'package:jobaventure/models/categorie.dart';
import 'detailsmetier.dart'; // Assurez-vous que le chemin est correct

class MetierCategoryPage extends StatelessWidget {
  final String categoryName;
  final List<Metier> metiers;

  MetierCategoryPage({required this.categoryName, required this.metiers});

  @override
  Widget build(BuildContext context) {
    // Vérifiez si la liste de métiers est nulle ou vide
    if (metiers == null || metiers.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
        ),
        body: Center(
          child: Text('Aucun métier trouvé pour cette catégorie.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Column(
        children: [
          // GridView of metiers
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Nombre de cartes par ligne
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.8, // Ajustement du ratio pour l'apparence
              ),
              padding: EdgeInsets.all(8.0),
              itemCount: metiers.length, // Utilisation de metiers.length
              itemBuilder: (context, index) {
                Metier metier = metiers[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailMetier(metier: metier),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: metier.imageUrl != null
                              ? Image.network(
                                  'http://localhost:8080/' + metier.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Gestion des erreurs de chargement d'image
                                    return Container(
                                      color: Colors.grey,
                                      child: Center(
                                        child: Text(
                                          'Erreur de chargement',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.grey,
                                  child: Center(child: Text('Aucune image')),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            metier.nom,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            metier.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54),
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

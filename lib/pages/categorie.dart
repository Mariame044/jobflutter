import 'package:flutter/material.dart';
import '../Service/metier_service.dart'; // Assurez-vous que le chemin d'importation est correct
import '../models/categorie.dart'; // Importez le modèle Categorie
import 'package:jobaventure/Service/auth_service.dart'; // Import de AuthService
import 'detailsmetier.dart';
import 'metierparcategorie.dart'; // Nouvelle page pour afficher les métiers par catégorie

class CategoriePage extends StatefulWidget {
  @override
  _CategoriePageState createState() => _CategoriePageState();
}

class _CategoriePageState extends State<CategoriePage> {
  late Future<List<Metier>> futureMetiers;
  final MetierService metierService = MetierService(AuthService()); // Injectez AuthService

  @override
  void initState() {
    super.initState();
    // Initialiser le futur pour charger les métiers
    futureMetiers = metierService.getAllMetiers(); // Assurez-vous que le nom de la méthode est correct
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Métiers par Catégorie'),
      ),
      body: FutureBuilder<List<Metier>>(
        future: futureMetiers,
        builder: (context, snapshot) {
          // Affichage d'un indicateur de chargement pendant que les données sont récupérées
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } 
          // Gestion des erreurs lors de la récupération des données
          else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } 
          // Si les données sont récupérées mais qu'aucun métier n'est trouvé
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun métier trouvé.'));
          }

          // Récupérer la liste des métiers et les grouper par catégorie
          List<Metier> metiers = snapshot.data!;
          Map<String, List<Metier>> metiersByCategorie = {};

          for (var metier in metiers) {
            String categoryName = metier.categorie?.nom ?? 'Non catégorisé'; // Accéder au nom de la catégorie
            metiersByCategorie.putIfAbsent(categoryName, () => []).add(metier);
          }

          // Affichage des catégories dans une grille
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Nombre de cartes par rangée
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1, // Ajustez le ratio pour l'apparence
              ),
              itemCount: metiersByCategorie.keys.length,
              itemBuilder: (context, index) {
                String categoryName = metiersByCategorie.keys.elementAt(index);
                List<Metier> metiersInCategory = metiersByCategorie[categoryName]!;

                return GestureDetector(
                  onTap: () {
                    // Naviguer vers la nouvelle page pour afficher les métiers de la catégorie
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MetierCategoryPage(
                          categoryName: categoryName,
                          metiers: metiersInCategory,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: metiersInCategory.isNotEmpty && metiersInCategory[0].imageUrl != null
                              ? Image.network(
                                  'http://localhost:8080/' + metiersInCategory[0].imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Gestion de l'erreur d'image
                                    return Container(
                                      color: Colors.grey,
                                      child: Center(child: Text('Erreur chargement image')),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.grey,
                                  child: Center(child: Text('Aucune image disponible')),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            categoryName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

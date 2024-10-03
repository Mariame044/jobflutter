// lib/screens/metier_list_screen.dart

import 'package:flutter/material.dart';
import '../Service/metier_service.dart'; // Assurez-vous que le chemin d'importation est correct
import '../models/categorie.dart'; // Importez le modèle Metier, vérifiez que le chemin est correct
// Assurez-vous d'importer le modèle Categorie
import 'package:jobaventure/Service/auth_service.dart'; // Import de AuthService
import 'detailsmetier.dart';

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
    futureMetiers = metierService.fetchMetiers();
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun métier trouvé.'));
          }

          List<Metier> metiers = snapshot.data!;
          Map<String, List<Metier>> metiersByCategorie = {};

          // Grouper les métiers par catégorie
          for (var metier in metiers) {
            String categoryName = metier.categorie.nom; // Accéder au nom de la catégorie
            if (metiersByCategorie.containsKey(categoryName)) {
              metiersByCategorie[categoryName]!.add(metier);
            } else {
              metiersByCategorie[categoryName] = [metier];
            }
          }

          return ListView(
            children: metiersByCategorie.entries.map((entry) {
              String categoryName = entry.key;
              List<Metier> metiersInCategory = entry.value;

              return ExpansionTile(
                title: Text(categoryName),
                children: metiersInCategory.map((metier) {
                  return ListTile(
                    title: Text(metier.nom),
                    subtitle: Text(metier.description),
                    leading: metier.imageUrl != null
                        ? Image.network(metier.imageUrl!)
                        : null,
                    onTap: () {
                      // Vérifiez si le widget est encore monté avant de naviguer
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailMetier(metier: metier),
                          ),
                        );
                      }
                    },
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

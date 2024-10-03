import 'package:flutter/material.dart';
import '../models/categorie.dart';

class DetailMetier extends StatelessWidget {
  final Metier metier;

  DetailMetier({required this.metier});

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
            // Vérifiez que l'imageUrl n'est pas nulle ou vide avant de charger l'image
            if (metier.imageUrl.isNotEmpty)
              Image.network(
                // Utilisez l'adresse IP de votre machine si vous testez sur un émulateur ou un appareil
                'http://localhost:8080/api/enfants/${metier.imageUrl}', 
                // Remplacez `<votre_adresse_ip>` par l'adresse IP de votre machine (par exemple, 192.168.1.10)
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Placeholder(); // Affichez un Placeholder en cas d'erreur
                },
              ),
            const SizedBox(height: 16),
            Text(
              metier.description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              'Catégorie: ${metier.categorie.nom}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/screens/detailmetier.dart

import 'package:flutter/material.dart';
import 'package:jobaventure/models/categorie.dart';
import 'package:jobaventure/models/video.dart';
import 'package:jobaventure/pages/videoparmetier.dart'; // Assurez-vous que le chemin d'importation est correct

class DetailMetier extends StatelessWidget {
  final Metier metier;
  final Video? video; // Assurez-vous que cela est défini

  const DetailMetier({Key? key, required this.metier, this.video}) : super(key: key);
  
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
            Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                     
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupedVideosScreen(),
                          ),
                        );
                    
                       
                      
                    },
                    child: Text('Video'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to MetierPage
                      // Implémentez votre logique ici
                    },
                    child: Text('Metier'),
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

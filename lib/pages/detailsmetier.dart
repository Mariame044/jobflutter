import 'package:flutter/material.dart';
import 'package:jobaventure/Service/interview.dart';
import 'package:jobaventure/Service/jeu.dart';
import 'package:jobaventure/Service/metier_service.dart';
import 'package:jobaventure/Service/video.dart';
import 'package:jobaventure/models/categorie.dart';
import 'package:jobaventure/models/interview.dart';
import 'package:jobaventure/models/jeu.dart';
import 'package:jobaventure/models/video.dart';
import 'package:jobaventure/pages/interviewparmetier.dart';
import 'package:jobaventure/pages/jeuparmetier.dart';

import 'package:jobaventure/pages/videoparmetier.dart';

class DetailMetier extends StatelessWidget {
  final Metier metier; // Instance du métier
  final InterviewService interviewService; // Instance du service interview
  final VideoService videoService; // Instance du service vidéo
  final JeuderoleService jeuderoleService;
  final MetierService metierService;

  const DetailMetier({
    Key? key,
    required this.metier,
    required this.jeuderoleService,
    required this.interviewService, // Service pour récupérer les interviews
    required this.videoService, // Service vidéo
    required this.metierService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
  backgroundColor: Colors.white,
  leading: IconButton(
    icon: Image.asset(
      'assets/images/d.png', // Remplace par le chemin correct
      width: 30,
      height: 30,
    ),
    onPressed: () => Navigator.pop(context), // Retour à l'écran précédent
  ),
  // Utilisation de `FlexibleSpace` pour centrer le titre
  flexibleSpace: Center(
    child: Padding(
      padding: const EdgeInsets.only(top: 16.0), // Ajuste si nécessaire
      child: Text(
        metier.nom,
        style: TextStyle(
          color: Color(0xFF036A94), // Couleur bleue pour le texte
          fontSize: 20, // Taille du texte
          fontWeight: FontWeight.bold, // Gras pour le rendre plus visible
        ),
      ),
    ),
  ),
),


      body: SingleChildScrollView( // Permet le défilement
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16), // Espace en haut
              // Section des boutons avec animations
Container(
  padding: EdgeInsets.all(14.0), // Padding autour du Wrap
  height: 100, // Définir une hauteur fixe pour le conteneur
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal, // Défilement horizontal
    child: Wrap(
      spacing: 20.0, // Espacement horizontal entre les boutons
      runSpacing: 20.0, // Espacement vertical entre les boutons
      alignment: WrapAlignment.center, // Centrer les boutons horizontalement
      children: [
        Container( // Ajout d'un Container pour le bouton Vidéo
          margin: EdgeInsets.symmetric(horizontal: 10.0), // Marges horizontales
          child: _buildAnimatedButton(
            context: context,
            label: 'Vidéo',
            color: Color(0xFF00BFFF), // Cyan clair
            textColor: Colors.white,
            onPressed: () async {
              await _handleVideoButton(context);
            },
          ),
        ),
        Container( // Ajout d'un Container pour le bouton Jeux
          margin: EdgeInsets.symmetric(horizontal: 10.0), // Marges horizontales
          child: _buildAnimatedButton(
            context: context,
            label: 'Jeux',
            color: Color(0xFFB0BEC5), // Gris clair
            textColor: Colors.black,
            onPressed: () async {
              await _handleJeuButton(context);
            },
          ),
        ),
        Container( // Ajout d'un Container pour le bouton Interviews
          margin: EdgeInsets.symmetric(horizontal: 10.0), // Marges horizontales
          child: _buildAnimatedButton(
            context: context,
            label: 'Interviews',
            color: Color(0xFF8BC34A), // Vert clair
            textColor: Colors.white,
            onPressed: () async {
              await _handleInterviewButton(context);
            },
          ),
        ),
        // Ajoutez d'autres boutons ici si nécessaire
      ],
    ),
  ),
),


              SizedBox(height: 16), // Espace entre les boutons et l'image
              // Afficher l'image du métier avec animation de zoom
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: metier.imageUrl != null
                      ? Image.network(
                          'http://localhost:8080/' + metier.imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 200,
                          color: Colors.grey,
                          child: Center(child: Text('Aucune image disponible')),
                        ),
                ),
              ),
              SizedBox(height: 16), // Espace entre l'image et le nom du métier
              // Nom du métier
              Text(
                metier.nom,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orangeAccent),
              ),
              SizedBox(height: 8), // Espace entre le nom et la description
              // Description du métier
              Text(
                metier.description,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 16), // Espace entre la description et la catégorie
              // Catégorie du métier
              if (metier.categorie != null)
                Text(
                  'Catégorie: ${metier.categorie!.nom}',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.blueGrey),
                ),
              SizedBox(height: 50), // Espace pour éviter le débordement
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour gérer le bouton Vidéo
  Future<void> _handleVideoButton(BuildContext context) async {
    await metierService.incrementerVueMetier(metier.id); // Incrémentation de la vue
    try {
      List<Video>? videos = await videoService.getVideosByMetierAndAge(metier.id);
      if (videos != null && videos.isNotEmpty) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                GroupedVideosScreen(videos: videos, jeuderoleService: jeuderoleService, interviewService: interviewService, videoService: videoService, metier: metier,),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucune vidéo disponible pour ce métier.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des vidéos: $e')),
      );
    }
  }

  // Méthode pour gérer le bouton Interviews
  Future<void> _handleInterviewButton(BuildContext context) async {
    await metierService.incrementerVueMetier(metier.id); // Incrémentation de la vue
    try {
      List<Interview>? interviews = await interviewService.getInterviewsByMetierAndAge(metier.id);
      if (interviews != null && interviews.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InterviewsByMetierPage(
              interviews: interviews,
              jeuderoleService: jeuderoleService,
              interviewService: interviewService,
              videoService: videoService,
              metier: metier,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucune interview disponible pour ce métier.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des interviews: $e')),
      );
    }
  }
  // Méthode pour gérer le bouton Vidéo
  Future<void> _handleJeuButton(BuildContext context) async {
    await metierService.incrementerVueMetier(metier.id); // Incrémentation de la vue
    try {
      List<Jeuderole>? jeuderoles = await jeuderoleService.getJeuderoleByMetierAndAge(metier.id);
      if (jeuderoles != null && jeuderoles.isNotEmpty) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                JeuxParMetierPage(jeuderoles: jeuderoles, jeuderoleService: jeuderoleService, interviewService: interviewService, videoService: videoService, metier: metier,),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucune vidéo disponible pour ce métier.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des vidéos: $e')),
      );
    }
  }

  // Méthode pour créer un bouton avec animation
  Widget _buildAnimatedButton({
    required BuildContext context,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500),
      tween: Tween<double>(begin: 1.0, end: 1.1),
      curve: Curves.elasticOut,
      builder: (context, double scale, child) {
        return Transform.scale(
          scale: scale,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
        );
      },
    );
  }
}

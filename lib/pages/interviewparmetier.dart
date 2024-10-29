import 'package:flutter/material.dart';
import 'package:jobaventure/Service/jeu.dart';
import 'package:jobaventure/Service/video.dart';
import 'package:jobaventure/models/categorie.dart';
import 'package:jobaventure/models/jeu.dart';
import 'package:jobaventure/models/video.dart';
import 'package:jobaventure/pages/detailinterview.dart';
import 'package:jobaventure/pages/jeuparmetier.dart';
import 'package:jobaventure/pages/videoparmetier.dart';

import '../Service/interview.dart';
import '../models/interview.dart';


class InterviewsByMetierPage extends StatelessWidget {
  final List<Interview>? interviews; // Liste de vidéos pour un métier
  final Metier metier; // Instance du métier
  final InterviewService interviewService; // Instance du service interview
  final VideoService videoService; // Instance du service vidéo
  final JeuderoleService jeuderoleService;


  const InterviewsByMetierPage({Key? key, this.interviews, required this.jeuderoleService, required this.interviewService, required this.videoService, required this.metier}) : super(key: key);

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
      
    ),
  ),
),
 body: Column(
        children: [
          // Ajout du container avec les boutons animés
          Container(
            padding: EdgeInsets.all(14.0), // Padding autour du Wrap
            child: Wrap(
              spacing: 20.0, // Espacement horizontal entre les boutons
              runSpacing: 20.0, // Espacement vertical entre les boutons
              alignment: WrapAlignment.center, // Centrer les boutons horizontalement
              children: [
                _buildAnimatedButton(
                  context: context,
                  label: 'Vidéo',
                  color: Color(0xFF00BFFF), // Cyan clair
                  textColor: Colors.white,
                  onPressed: () async {
                    await _handleVideoButton(context);
                  },
                ),
                _buildAnimatedButton(
                  context: context,
                  label: 'Jeux',
                  color: Color(0xFFB0BEC5), // Gris clair
                  textColor: Colors.black,
                 onPressed: () async {
                    await _handleJeuButton(context);
                  },
                ),
                _buildAnimatedButton(
                  context: context,
                  label: 'Interviews',
                  color: Color(0xFF8BC34A), // Vert clair
                  textColor: Colors.white,
                  onPressed: () async {
                    await _handleInterviewButton(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: interviews == null || interviews!.isEmpty
                ? Center(
                    child: Text(
                      'Aucune interview disponible pour ce métier',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: interviews!.length,
                    itemBuilder: (context, index) {
                      Interview interview = interviews![index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Marge autour de chaque carte
                        elevation: 4.0, // Ajout d'une ombre
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0), // Coins arrondis
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0), // Espacement à l'intérieur de la carte
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8.0), // Espacement entre le titre et la description
                              // Description de la vidéo
                              Text(
                                interview.description ?? 'Aucune description',
                                style: TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                               
                              SizedBox(height: 12.0), // Espacement sous la description
                              // Ajouter un bouton ou un lien pour voir la vidéo
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Naviguer vers l'écran de détail vidéo
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InterviewDetailPage(interviewId: interview.id, interviewService: interviewService,),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.record_voice_over), // Icône de lecture
                                label: Text('Voir la interview'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent, // Couleur du bouton
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0), // Coins arrondis
                                  ),
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

  Widget _buildAnimatedButton({
    required BuildContext context,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Coins arrondis
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 16, color: textColor),
      ),
    );
  }

 
 Future<void> _handleVideoButton(BuildContext context) async {
    try {
      List<Video>? videos = await videoService.getVideosByMetierAndAge(metier.id);
      if (videos != null && videos.isNotEmpty) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                GroupedVideosScreen(
                  videos: videos,
                  jeuderoleService: jeuderoleService,
                  interviewService: interviewService,
                  videoService: videoService,
                  metier: metier,
                ),
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

  Future<void> _handleJeuButton(BuildContext context) async {
    try {
      List<Jeuderole>? jeuderoles = await jeuderoleService.getJeuderoleByMetierAndAge(metier.id);
      if (jeuderoles != null && jeuderoles.isNotEmpty) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                JeuxParMetierPage(
                  jeuderoles: jeuderoles,
                  jeuderoleService: jeuderoleService,
                  interviewService: interviewService,
                  videoService: videoService,
                  metier: metier,
                ),
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
          SnackBar(content: Text('Aucun jeu disponible pour ce métier.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des jeux: $e')),
      );
    }
  }
  // Méthode pour gérer le bouton Interviews
  Future<void> _handleInterviewButton(BuildContext context) async {
   
  }
}
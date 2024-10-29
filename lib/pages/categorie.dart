import 'package:flutter/material.dart';
import 'package:jobaventure/Service/jeu.dart';
import 'package:jobaventure/Service/quiz.dart';

import 'package:jobaventure/pages/button_nav.dart';
import 'package:jobaventure/pages/home.dart';
import 'package:jobaventure/pages/profile.dart';
import 'package:jobaventure/pages/quizparmetier.dart';
import '../Service/metier_service.dart';
import '../models/categorie.dart'; 
import 'package:jobaventure/Service/auth_service.dart'; 

import 'Metierparcategorie.dart'; 
import '../Service/video.dart'; 
import 'package:jobaventure/Service/interview.dart';

class CategoriePage extends StatefulWidget {
  @override
  _CategoriePageState createState() => _CategoriePageState();
}

class _CategoriePageState extends State<CategoriePage> {
  late Future<List<Metier>> futureMetiers;
  int _currentIndex = 0;
  final AuthService authService = AuthService(); 
  final MetierService metierService;
  late final VideoService videoService;
  late final JeuderoleService jeuderoleService;
  late final InterviewService interviewService;
  final QuizService quizService = QuizService(AuthService());
  
  _CategoriePageState() : metierService = MetierService(AuthService()) {
    videoService = VideoService(authService);
    interviewService = InterviewService(authService); 
    jeuderoleService = JeuderoleService(authService); 
  }

  @override
  void initState() {
    super.initState();
    futureMetiers = metierService.getAllMetiers(); 
  }

  // Méthode pour obtenir la couleur de la catégorie
  Color _getCategoryColor(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'technologie':
        return Colors.blueAccent;
      case 'santé':
        return Colors.greenAccent;
      case 'éducation':
        return Colors.orangeAccent;
      case 'artisanat':
        return Colors.purpleAccent;
      case 'dessin':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
        break;
      case 1:
       
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
      case 3:
       Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => QuizParMetierPage(quizService: quizService,),
        ));

        break;
    }
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

          for (var metier in metiers) {
            String categoryName = metier.categorie?.nom ?? 'Non catégorisé';
            metiersByCategorie.putIfAbsent(categoryName, () => []).add(metier);
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1,
              ),
              itemCount: metiersByCategorie.keys.length,
              itemBuilder: (context, index) {
                String categoryName = metiersByCategorie.keys.elementAt(index);
                List<Metier> metiersInCategory = metiersByCategorie[categoryName]!;
                Color categoryColor = _getCategoryColor(categoryName);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MetierCategoryPage(
                          categoryName: categoryName,
                          metiers: metiersInCategory,
                          interviewService: interviewService,
                          videoService: videoService,
                          jeuderoleService: jeuderoleService, metierService: metierService,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: metiersInCategory.isNotEmpty && metiersInCategory[0].imageUrl != null
                              ? Image.network(
                                  'http://localhost:8080/' + metiersInCategory[0].imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
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
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          color: categoryColor, // Utiliser la couleur dynamique
                          child: Text(
                            categoryName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}

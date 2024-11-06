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

class _CategoriePageState extends State<CategoriePage> with SingleTickerProviderStateMixin {
  late Future<List<Metier>> futureMetiers;
  int _currentIndex = 0;
  final AuthService authService = AuthService();
  final MetierService metierService;
  late final VideoService videoService;
  late final JeuderoleService jeuderoleService;
  late final InterviewService interviewService;
  final QuizService quizService = QuizService(AuthService());
  late AnimationController _controller;

  _CategoriePageState() : metierService = MetierService(AuthService()) {
    videoService = VideoService(authService);
    interviewService = InterviewService(authService);
    jeuderoleService = JeuderoleService(authService);
  }

  @override
  void initState() {
    super.initState();
    futureMetiers = metierService.getAllMetiers();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Méthode pour obtenir la couleur de la catégorie
  Color _getCategoryColor(String categoryName) {
  switch (categoryName.toLowerCase()) {
    case 'technologie':
      return Colors.blueAccent;  // Couleur pour la catégorie technologie
    case 'santé':
      return Colors.greenAccent;  // Couleur pour la catégorie santé
    case 'éducation':
      return Colors.orangeAccent;  // Couleur pour la catégorie éducation
    case 'Menuiserie':
      return Colors.purpleAccent;  // Couleur pour la catégorie artisanat
    case 'dessin':
      return Colors.redAccent;     // Couleur pour la catégorie dessin
    case 'musique':
      return Colors.tealAccent;    // Couleur pour la catégorie musique
    case 'arts':
      return Colors.yellowAccent;   // Couleur pour la catégorie sport
    default:
      return Colors.grey;           // Couleur par défaut
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
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
      case 3:
       Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => QuizParMetierPage(quizService: quizService),
        ));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Métiers par Catégorie'),
        backgroundColor: Colors.white,
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
  padding: const EdgeInsets.symmetric(horizontal: 12.0), // Ajoutez plus d'espace ici pour agrandir les cartes globalement
  child: GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 20.0, // Espace horizontal entre les cartes
      mainAxisSpacing: 20.0,  // Espace vertical entre les cartes
      childAspectRatio: 0.8,  // Diminuez pour des cartes plus hautes
    ),
    itemCount: metiersByCategorie.keys.length,
    itemBuilder: (context, index) {
      String categoryName = metiersByCategorie.keys.elementAt(index);
      List<Metier> metiersInCategory = metiersByCategorie[categoryName]!;
      Color categoryColor = _getCategoryColor(categoryName);

      return GestureDetector(
        onTap: () {
          _controller.forward().then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MetierCategoryPage(
                  categoryName: categoryName,
                  metiers: metiersInCategory,
                  interviewService: interviewService,
                  videoService: videoService,
                  jeuderoleService: jeuderoleService,
                  metierService: metierService, 
                ),
              ),
            );
            _controller.reset();
          });
        },
        child: ScaleTransition(
          scale: Tween<double>(begin: 1, end: 1.05).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          ),
          child: Card(
            elevation: 6, // Ajoutez de l'élévation pour un effet de carte
            color: categoryColor, // Définit la couleur de la carte

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: metiersInCategory.isNotEmpty && metiersInCategory[0].imageUrl != null
                      ? ClipRRect(
                          child: FadeInImage.assetNetwork(
                            placeholder: 'images/Loading_icon.gif',
                            image: 'http://localhost:8080/' + metiersInCategory[0].imageUrl!,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey,
                                child: Icon(Icons.close, color: Colors.redAccent, size: 40),
                              );
                            },
                          ),
                        )
                      : Container(
                          color: Colors.grey,
                          child: Center(child: Text('Aucune image disponible')),
                        ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6), // Assombrit le fond de la zone de texte
                  ),
                  child: Column(
                    children: [
                      Text(
                        categoryName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${metiersInCategory.length} métiers',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

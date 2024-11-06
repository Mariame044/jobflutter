import 'package:flutter/material.dart';
import 'package:jobaventure/Service/quiz.dart';
import 'package:jobaventure/models/categorie.dart';
import 'package:jobaventure/pages/Metierparcategorie.dart';
import 'package:jobaventure/pages/a.dart';
import 'package:jobaventure/pages/categorie.dart';
import 'package:jobaventure/pages/profile.dart';
import 'package:jobaventure/pages/quizparmetier.dart';
import '../Service/metier_service.dart'; // Import du service des métiers
import 'button_nav.dart'; // Import du widget BottomNavigation
import 'package:jobaventure/Service/auth_service.dart'; // Import du AuthService

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _isSearching = false; // État pour savoir si la recherche est active
  TextEditingController _searchController = TextEditingController(); // Contrôleur de texte
  late Future<List<Metier>> futureMetiers; // Future pour récupérer les métiers
  final MetierService metierService = MetierService(AuthService());
    final QuizService quizService = QuizService(AuthService());
  
  @override
  void initState() {
    super.initState();
    // Initialiser le futur pour charger les métiers
    futureMetiers = metierService.getAllMetiers(); // Assurez-vous que cette méthode existe et fonctionne
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
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CategoriePage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => QuizParMetierPage(quizService: quizService,),
        ));
        break;
    }
  }

  // Méthode pour basculer l'état de recherche
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear(); // Effacer le champ de recherche
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section du haut avec le fond en dégradé
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ Color(0xFFEDEDFF),  Color(0xFFEDEDFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Image.asset('assets/images/logo.png', width: 200),

                  IconButton(
                    icon: Icon(
                      _isSearching ? Icons.close : Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: _toggleSearch,
                  ),
                ],
              ),
            ),

            // Afficher la barre de recherche si nécessaire
            if (_isSearching)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Rechercher un métier',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 20), 
              // Espace entre le conteneur et le texte
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
               child:Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Aligne les enfants au début
                children: [
                  Expanded(
                    child: Column(
                      
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         
                        Text(
                          "Salut, Explorateur!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Prêt à explorer le monde fascinant des métiers ? "
                          "Découvre, joue et apprends avec nous.",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  // Affichage des images en haut et en bas
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start, // Aligne les images en haut
                    crossAxisAlignment: CrossAxisAlignment.center, // Centre les images
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Centre les images
                        children: [
                          ClipRRect(
                            child: Image.asset(
                             'assets/images/ss.png', // Remplacez par le chemin de l'image réelle
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          ClipRRect(
                            child: Image.asset(
                              'assets/images/cc.png', // Remplacez par le chemin de l'image réelle
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      ClipRRect(
                        child: Image.asset(
                          'assets/images/ad.png', // Remplacez par le chemin de l'image réelle
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ),
              SizedBox(height: 20),
               // Section des catégories
              Padding(
               padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Les différentes Categories",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                       Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CategoriePage(),
        ));
                    },
                    child: Text("Voir tout"),
                  ),
                ],
              ), // Espace entre les images et les catégories
              ),
              // FutureBuilder pour afficher les catégories dynamiques
              FutureBuilder<List<Metier>>(
                future: futureMetiers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucune catégorie trouvée.'));
                  }

                  List<Metier> metiers = snapshot.data!;
                  Map<String, List<Metier>> metiersByCategorie = {};

                  // Grouper les métiers par catégorie
                  for (var metier in metiers) {
                    String categoryName = metier.categorie?.nom ?? 'Non catégorisé';
                    if (metiersByCategorie.containsKey(categoryName)) {
                      metiersByCategorie[categoryName]!.add(metier);
                    } else {
                      metiersByCategorie[categoryName] = [metier];
                    }
                  }

                  // Transform categories into a list
                  List<String> categoryNames = metiersByCategorie.keys.toList();

                  // Build ListView with horizontal scrolling
                  return Container(
                    height: 160, // Set a fixed height for the horizontal list
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryNames.length,
                      itemBuilder: (context, index) {
                        String categoryName = categoryNames[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _buildCategoryCard(
                            'http://localhost:8080/' + (metiersByCategorie[categoryName]![0].imageUrl ?? ''),
                            categoryName,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20), 
               Center(
                child: Text(
                  "Découvre ton futur métier !!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
// Espace entre le bouton et le bas de l'écran
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligne les enfants au début
              children: [
                // Affichage des images en haut et en bas
                Column(
                  mainAxisAlignment: MainAxisAlignment.start, // Aligne les images en haut
                  crossAxisAlignment: CrossAxisAlignment.center, // Centre les images
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Centre les images
                      children: [
                        // Vous pouvez ajuster les marges selon vos besoins
                        Image.asset(
                          'assets/images/q.png', 
                          width: 150, // Largeur augmentée
                          height: 200, // Hauteur augmentée
                          fit: BoxFit.cover, // Pour ajuster l'image dans le conteneur
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 0), // Espace entre l'image et le texte
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 0),
                      Text(
                        "Avec Job aventure, tu as la chance d'explorer des carrières passionnantes et de comprendre ce que signifie vraiment chaque métier. Ensemble, faisons de ton rêve une réalité !",
                      ),
                      // Espace entre les cartes et le bouton
                      ElevatedButton(
                        onPressed: () {
                          // Action pour le bouton
                        },
                        child: Text('Explorez les Métiers'),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
  // Méthode pour générer une couleur en fonction de la catégorie
Color _getCategoryColor(String categoryName) {
  switch (categoryName.toLowerCase()) {
    case 'technologie':
      return Colors.blueAccent; // Couleur pour la catégorie 'Technologie'
    case 'santé':
      return Colors.greenAccent; // Couleur pour la catégorie 'Santé'
    case 'éducation':
      return Colors.orangeAccent; // Couleur pour la catégorie 'Éducation'
    case 'artisanat':
      return Colors.purpleAccent; // Couleur pour la catégorie 'Artisanat'
    case 'dessin':
      return Colors.redAccent; // Couleur pour la catégorie 'Commerce'
    default:
      return Colors.grey; // Couleur par défaut
  }
}

  // Méthode pour créer une carte de catégorie
 Widget _buildCategoryCard(String imagePath, String categoryName) {
  Color categoryColor = _getCategoryColor(categoryName); // Obtenir la couleur en fonction de la catégorie

  return Card(
    elevation: 4,
    child: Container(
      width: 200, // Largeur du conteneur ajustée
      height: 200, // Hauteur ajustée pour l'image et le texte
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Permet à l'image de prendre toute la largeur
        children: [
          // L'image prend toute la largeur du conteneur
          Expanded(
            child: imagePath.isNotEmpty
                ? Image.network(
                    imagePath,
                    fit: BoxFit.cover, // L'image couvre toute la surface disponible
                  )
                : Container(
                    color: Colors.grey,
                    child: Center(child: Text('Pas d\'image')),
                  ),
          ),
          // Section en bas avec une couleur pour afficher le nom de la catégorie
          Container(
            padding: const EdgeInsets.all(8.0),
            color: categoryColor, // Couleur dynamique basée sur la catégorie
            child: Text(
              categoryName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Texte en blanc pour contraster avec le fond
              ),
              textAlign: TextAlign.center, // Centre le texte
            ),
          ),
        ],
      ),
    ),
  );
}
}

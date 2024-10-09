import 'package:flutter/material.dart';
import 'package:jobaventure/models/categorie.dart';
import 'package:jobaventure/pages/Metierparcategorie.dart';
import 'package:jobaventure/pages/a.dart';
import 'package:jobaventure/pages/categorie.dart';
import '../Service/metier_service.dart'; // Import du service des métiers
import 'button_nav.dart'; // Importez le widget BottomNavigation
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
          builder: (context) => JobAdventureHomePage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CategoriePage(),
        ));
        break;
      case 2:
        Navigator.pushNamed(context, '/profile'); // Remplacez cela par votre écran de profil
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Conteneur avec fond bleu contenant le logo et la barre de recherche
              Container(
                color: Colors.blue, // Couleur de fond bleu
                padding: const EdgeInsets.symmetric(vertical: 16.0), // Espacement vertical
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacement entre les éléments
                  children: [
                    // Logo
                    Image.asset(
                      'images/logo.png', // Remplacez ceci par le chemin de votre logo
                      height: 50, // Ajustez la hauteur selon vos besoins
                    ),
                    // Icône de recherche
                    IconButton(
                      icon: Icon(
                        _isSearching ? Icons.close : Icons.search, // Icône selon l'état
                        color: Colors.white,
                      ),
                      onPressed: _toggleSearch, // Bascule l'état de recherche
                    ),
                  ],
                ),
              ),
              // Affichage conditionnel de la barre de recherche
              if (_isSearching)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0), // Espacement supérieur
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Rechercher un métier',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      fillColor: Colors.white, // Couleur de fond de la barre de recherche
                      filled: true, // Remplir le fond
                    ),
                  ),
                ),
              SizedBox(height: 20), // Espace entre le conteneur et le texte
               Row(
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
                              'images/ac.png', // Remplacez par le chemin de l'image réelle
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                         // SizedBox(width: 10),
                          ClipRRect(
                            child: Image.asset(
                              'images/ab.png', // Remplacez par le chemin de l'image réelle
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      //SizedBox(height: 10), // Espace entre les lignes d'images
                      ClipRRect(
                        child: Image.asset(
                          'images/ac.png', // Remplacez par le chemin de l'image réelle
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
               // Section des catégories
              Row(
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
              'images/DDD.png', 
              width: 150, // Largeur augmentée
              height: 150, // Hauteur augmentée
              fit: BoxFit.cover, // Pour ajuster l'image dans le conteneur
            ),
          ],
        ),
      ],
    ),
    SizedBox(width: 16), // Espace entre l'image et le texte
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          SizedBox(height: 8),
          Text(
            "Avec Job aventure, tu as la chance d'explorer des carrières passionnantes et de comprendre ce que signifie vraiment chaque métier. Ensemble, faisons de ton rêve une réalité !",
          ),
           // Espace entre les cartes et le bouton
              ElevatedButton(
                onPressed: () {
                  //  Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => MetierCategoryPage(
                         
                         
                  //       ),
                  //     ),
                  //   );
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
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }

  // Méthode pour créer une carte de catégorie
  Widget _buildCategoryCard(String imagePath, String categoryName) {
    return Card(
      elevation: 4,
      child: Container(
        width: 200, // Largeur ajustée pour les cartes de catégorie
        height: 200, // Hauteur ajustée pour éviter le débordement
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imagePath.isNotEmpty
                ? Image.network(
                    imagePath,
                    height: 100, // Hauteur ajustée pour l'image
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 100,
                    color: Colors.grey,
                    child: Center(child: Text('Pas d\'image')),
                  ),
            SizedBox(height: 10),
            Text(
              categoryName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center, // Centrer le texte
            ),
          ],
        ),
      ),
    );
  }
}

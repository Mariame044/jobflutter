import 'package:flutter/material.dart';

void main() {
  runApp(JobAdventureApp());
}

class JobAdventureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Adventure',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JobAdventureHomePage(),
    );
  }
}

class JobAdventureHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/aa.png', // Ajoutez ici le logo de votre application
          height: 50,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Texte d'accueil et images
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
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'images/rr.png', // Remplacez par le chemin de l'image réelle
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'images/ab.png', // Remplacez par le chemin de l'image réelle
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10), // Espace entre les lignes d'images
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'images/ac.png', // Remplacez par le chemin de l'image réelle
                          height: 80,
                          width: 80,
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
                    onPressed: () {},
                    child: Text("Voir tout"),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Cartes de catégorie
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  CategoryCard(
                    title: 'Design',
                    imagePath: 'assets/design_category.jpg',
                    bgColor: Colors.green,
                  ),
                  CategoryCard(
                    title: 'Tech',
                    imagePath: 'assets/tech_category.jpg',
                    bgColor: Colors.orange,
                  ),
                  CategoryCard(
                    title: 'Marketing',
                    imagePath: 'assets/marketing_category.jpg',
                    bgColor: Colors.green,
                  ),
                  CategoryCard(
                    title: 'Finance',
                    imagePath: 'assets/finance_category.jpg',
                    bgColor: Colors.orange,
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Texte de pied de page
              Text(
                "Découvre ton futur métier!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Avec 'Job aventure', tu as la chance d'explorer des carrières passionnantes "
                "et de comprendre ce qui symbolise vraiment chaque métier. Ensemble, faisons "
                "de ton rêve une réalité !",
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color bgColor;

  CategoryCard({
    required this.title,
    required this.imagePath,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

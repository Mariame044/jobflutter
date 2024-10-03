import 'package:flutter/material.dart';

import 'package:jobaventure/pages/categorie.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Aventure'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Salut, Explorateur !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
           
            ElevatedButton(
              onPressed: () {
                
              },
              child: Text('Explorez les Métiers'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Catégories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Logique de navigation
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/'); // Accueil
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
      ),
    );
  }
}

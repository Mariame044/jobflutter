import 'package:flutter/material.dart';
import 'package:jobaventure/pages/categorie.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap; // Utiliser ValueChanged pour la fonction onTap

  const BottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
           BottomNavigationBarItem(
          icon: Icon(Icons.quiz),
          label: 'Quiz',
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.blue, // Couleur pour l'élément sélectionné
      unselectedItemColor: Colors.grey, // Couleur pour les éléments non sélectionnés
      showUnselectedLabels: true, // Afficher les labels non sélectionnés
      showSelectedLabels: true, // Afficher les labels sélectionnés
    );
  }
}

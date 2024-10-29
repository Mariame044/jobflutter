import 'package:flutter/material.dart';
import 'package:jobaventure/Service/auth_service.dart';
import 'package:jobaventure/Service/enfant.dart';
import 'package:jobaventure/Service/profile.dart';
import 'package:jobaventure/Service/quiz.dart';
import 'package:jobaventure/models/RegisterUserDto.dart';
import 'package:jobaventure/models/categorie.dart';
import 'package:jobaventure/pages/a.dart';
import 'package:jobaventure/pages/categorie.dart';
import 'package:jobaventure/pages/button_nav.dart';
import 'package:jobaventure/pages/enfant.dart';
import 'package:jobaventure/pages/home.dart';
import 'package:jobaventure/pages/login.dart';
import 'package:jobaventure/pages/modifierprofile.dart';
import 'package:jobaventure/pages/quizparmetier.dart'; // Importez la nouvelle page

class ProfilePage extends StatefulWidget {
 
  @override
  
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 2; // Par défaut sur la page "Profil"
  final AuthService _authService = AuthService(); // Instance de AuthService
  final ProfileService _profileService = ProfileService(); // Instance de ProfileService
  final QuizService quizService = QuizService(AuthService());
  final EnfantService _enfantService = EnfantService(AuthService());
 
  String? _username; // Variable pour stocker le nom d'utilisateur
  String? _imageUrl; // Variable pour stocker l'URL de l'image
  Users? _currentUser; // Variable pour stocker l'utilisateur actuel

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigation vers différentes pages
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
        break;
      case 1:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => CategoriePage(),
        ));
       case 3:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => QuizParMetierPage(quizService: quizService,),
        ));
        break;
      case 2:
          
        // Rester sur la page de profil
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Charger les données de l'utilisateur lors de l'initialisation
  }

  Future<void> _loadUserData() async {
    // Récupérer les données de l'utilisateur via votre API
    try {
      _currentUser = await _profileService.getCurrentUser(); // Remplacez par l'appel API approprié
      setState(() {
        _username = _currentUser?.nom; // Mettez à jour le nom d'utilisateur
        _imageUrl = _currentUser?.imageUrl != null ? 'http://localhost:8080/${_currentUser!.imageUrl}' : null; // Construire l'URL de l'image
      });
    } catch (e) {
      // Gérer les erreurs ici
      setState(() {
        _username = 'Erreur de chargement'; // Afficher un message d'erreur
      });
    }
  }

  Future<void> _logout() async {
    await _authService.logout(); // Appel à la méthode de déconnexion
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoginPage(), // Rediriger vers la page d'accueil ou de connexion
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        centerTitle: true, // Centre le titre
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar de profil
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: _imageUrl != null && _imageUrl!.isNotEmpty
                  ? NetworkImage(_imageUrl!) // Utiliser l'image récupérée
                  : null, // Pas d'image à afficher
              child: _imageUrl == null || _imageUrl!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.blue, // Couleur de l'icône
                    )
                  : null, // Pas d'icône si une image est affichée
            ),
            SizedBox(height: 16),
            Text(
              _username ?? 'Chargement...', // Afficher le nom d'utilisateur ou un texte de chargement
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            // Options de profil
            ProfileOption(
              icon: Icons.bar_chart,
              label: 'Progression',
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProgressionPage(enfantService: _enfantService,), // Navigation vers EditProfilePage
                    ),
                  );
              },
            ),
            ProfileOption(
              icon: Icons.lock,
              label: 'Modifier le profil', // Modification de l'étiquette
              onTap: () {
                if (_currentUser != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(user: _currentUser!), // Navigation vers EditProfilePage
                    ),
                  );
                }
              },
            ),
            ProfileOption(
              icon: Icons.logout,
              label: 'Déconnexion',
              onTap: _logout, // Appel à la fonction de déconnexion
            ),
          ],
        ),
      ),
      // Ajout de la barre de navigation inférieure
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}

// Widget personnalisé pour les options de profil
class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileOption({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0), // Espacement vertical
        padding: EdgeInsets.all(16.0), // Espacement interne
        decoration: BoxDecoration(
          color: Colors.grey[200], // Couleur de fond
          borderRadius: BorderRadius.circular(8.0), // Coins arrondis
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue), // Icône
            SizedBox(width: 16), // Espacement entre l'icône et le texte
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

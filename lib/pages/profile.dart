import 'package:flutter/material.dart';
import 'package:jobaventure/Service/auth_service.dart';
import 'package:jobaventure/Service/enfant.dart';
import 'package:jobaventure/Service/profile.dart';
import 'package:jobaventure/Service/quiz.dart';
import 'package:jobaventure/models/RegisterUserDto.dart';
import 'package:jobaventure/pages/categorie.dart';
import 'package:jobaventure/pages/enfant.dart';
import 'package:jobaventure/pages/home.dart';
import 'package:jobaventure/pages/login.dart';
import 'package:jobaventure/pages/modifierprofile.dart';
import 'package:jobaventure/pages/quizparmetier.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 2; // Default to Profile page
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();
  final QuizService quizService = QuizService(AuthService());
  final EnfantService _enfantService = EnfantService(AuthService());

  String? _username;
  String? _imageUrl;
  Users? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      _currentUser = await _profileService.getCurrentUser();
      setState(() {
        _username = _currentUser?.nom;
        _imageUrl = _currentUser?.imageUrl != null ? 'http://localhost:8080/${_currentUser!.imageUrl}' : null;
      });
    } catch (e) {
      setState(() {
        _username = 'Erreur de chargement';
      });
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoginPage(),
    ));
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
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
        break;
      case 3:
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => QuizParMetierPage(quizService: quizService),
        ));
        break;
      case 2:
        // Stay on Profile Page
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Mon Profil',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal[100],
              backgroundImage: _imageUrl != null && _imageUrl!.isNotEmpty
                  ? NetworkImage(_imageUrl!)
                  : null,
              child: _imageUrl == null || _imageUrl!.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white70,
                    )
                  : null,
            ),
            SizedBox(height: 16),
            Text(
              _username ?? 'Chargement...',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.teal[900],
              ),
            ),
            SizedBox(height: 30),
            _buildProfileOption(
              icon: Icons.bar_chart,
              label: 'Progression',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProgressionPage(enfantService: _enfantService),
                  ),
                );
              },
            ),
            _buildProfileOption(
              icon: Icons.person,
              label: 'Modifier le profil',
              onTap: () {
                if (_currentUser != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(user: _currentUser!),
                    ),
                  );
                }
              },
            ),
            _buildProfileOption(
              icon: Icons.logout,
              label: 'Déconnexion',
              onTap: _logout,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onTap,
        items: [
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
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal, size: 30),
            SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.teal[900],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

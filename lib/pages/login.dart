import 'package:flutter/material.dart';
import 'package:jobaventure/pages/home.dart';
import 'package:jobaventure/pages/incrisption.dart';
import '../Service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importation de shared_preferences

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = '';
  bool _isLoading = false; // Ajout d'un état de chargement

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Vérification du statut de connexion
  }

  // Vérifier si l'utilisateur est déjà connecté
  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token'); // Récupération du token stocké

    if (token != null) {
      // Si un token existe, redirection vers la page d'accueil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  // Fonction pour gérer la connexion
  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    AuthService apiService = AuthService();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        message = 'Veuillez entrer votre email et votre mot de passe.';
      });
      return; // Sortir si les champs sont vides
    }

    setState(() {
      _isLoading = true; // Activer l'indicateur de chargement
      message = ''; // Réinitialiser le message d'erreur
    });

    try {
      final response = await apiService.login(email, password);
      print(response); // Pour déboguer la réponse

      if (response['statusCode'] == 200) {
        // Stocker le token si la connexion réussit
        String token = response['token'];

        // Sauvegarder le token dans shared_preferences pour le stockage local
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token); // Stockage du token

        // Récupération du rôle de l'utilisateur
        String role = response['role']['nom'];

        // Redirection en fonction du rôle
        if (role == "PARENT" || role == "Enfant") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()), // Page pour les parents ou enfants
          );
        }
      } else {
        setState(() {
          message = 'Échec de la connexion : ${response['message']}';
        });
      }
    } catch (e) {
      print('Erreur : $e'); // Pour le débogage
      setState(() {
        message = 'Erreur : ${e.toString()}'; // Message d'erreur plus général
      });
    } finally {
      setState(() {
        _isLoading = false; // Désactiver l'indicateur de chargement
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page de Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : login, // Désactiver le bouton pendant le chargement
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white) // Indicateur de chargement
                  : Text('Se connecter'),
            ),
            SizedBox(height: 20),
            Text(message, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()), // Naviguer vers la page d'inscription
                );
              },
              child: Text('Pas encore de compte ? Inscrivez-vous ici.'),
            ),
          ],
        ),
      ),
    );
  }
}

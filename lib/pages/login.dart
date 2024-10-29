import 'package:flutter/material.dart';
import 'package:jobaventure/pages/home.dart';
import 'package:jobaventure/pages/incrisption.dart';
import 'package:jobaventure/pages/parent.dart';
import '../Service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importation de shared_preferences

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Vérification du statut de connexion
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token'); // Récupération du token stocké
    String? role = prefs.getString('role'); // Vérification du rôle stocké

    if (token != null) {
      // Si un token existe, redirection vers la page d'accueil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    AuthService apiService = AuthService();

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await apiService.login(email, password);
      if (response['statusCode'] == 200) {
        String token = response['token'];
        
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        String role = response['role']['nom'];
       // Redirection en fonction du rôle de l'utilisateur
        if (role == "Parent") {
          // Si l'utilisateur est un parent, redirection vers EnfantSupervisionPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EnfantSupervisionPage()),
          );
        } else if (role == "Enfant") {
          // Si l'utilisateur est un enfant, redirection vers la page d'accueil (ou une autre page)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } else {
        print('Login failed: ${response['message']}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fond blanc
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              // Illustration au-dessus du formulaire
              Center(
                child: Image.asset(
                  'assets/images/logo.png', // Remplacez par votre illustration
                  height: 180,
                ),
              ),
              SizedBox(height: 20),
              // Conteneur de formulaire avec ombre
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF036A94), // Couleur de fond
                  borderRadius: BorderRadius.circular(30), // Bordure arrondie
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // décalage de l'ombre
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Prêt à entrer dans l aventure ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Connecte-toi !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Champ de saisie Email
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined, color: Colors.black54),
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Champ de saisie Password
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.black54),
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(height: 20),
                    // Bouton de connexion
                    Center(
                      child: SizedBox(
                        width: 200, // Largeur du bouton
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : login,
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Connexion',
                                  style: TextStyle(fontSize: 18, color: Colors.blue), // Couleur du texte en bleu
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Couleur de fond du bouton
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Color(0xFF036A94)), // Optionnel : ajouter une bordure
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Lien vers l'inscription
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignupScreen()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "je suis un nouvel utilisateur.  ",
                            style: TextStyle(color: Colors.white),
                            children: [
                              TextSpan(
                                text: 'Inscris toi?',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

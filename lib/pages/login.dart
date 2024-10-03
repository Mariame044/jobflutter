// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:jobaventure/pages/home.dart';
import '../Service/auth_service.dart';
import '../models/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = '';

  void login() async {
    String email = emailController.text;
    String password = passwordController.text;
    AuthService apiService = AuthService();

    try {
      final response = await apiService.login(email, password);
      print(response); // Pour déboguer la réponse
      
      if (response['statusCode'] == 200) {
        // Récupérer le rôle de l'utilisateur
        String role = response['role']['nom'];
        
        // Redirection en fonction du rôle
        if (role == "PARENT") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()), // Page pour les parents
          );
        } else if (role == "Enfant") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()), // Page pour les enfants
          );
        }
        
        // Optionnel : stocker le token si nécessaire
        String token = response['token'];
        // Vous pouvez stocker le token dans une variable ou utiliser un package comme shared_preferences
        
      } else {
        setState(() {
          message = 'Login failed: ${response['message']}';
        });
      }
    } catch (e) {
      print('Error: $e'); // Pour le débogage
      setState(() {
        message = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            Text(message, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}


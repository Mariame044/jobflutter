// lib/screens/signup_confirmation_page.dart

import 'package:flutter/material.dart';
import 'login.dart'; // Assurez-vous que le chemin d'importation est correct

class SignupConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription réussie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Votre inscription a été réussie !',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Vous pouvez maintenant vous connecter à votre compte.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page de connexion
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Connectez-vous maintenant'),
            ),
          ],
        ),
      ),
    );
  }
}

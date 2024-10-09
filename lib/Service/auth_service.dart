// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobaventure/models/RegisterUserDto.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Ajoutez cette importation pour le stockage local
import '../models/auth.dart';

class AuthService {
  final String baseUrl = "http://localhost:8080/auth"; // Remplacez par l'URL de votre API



  // Méthode pour se connecter
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Décodez la réponse JSON
        Map<String, dynamic> authData = json.decode(response.body);
        
        // Sauvegarder le token dans le stockage local
        await _saveToken(authData['token']);
        
        return authData; // Retourne les données d'authentification
      } else {
        throw Exception('Failed to log in: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  Future<void> signup(RegisterUserDto input) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(input.toJson()),
    );

    if (response.statusCode != 201) {
      // Si la réponse n'est pas OK, lancez une exception
      throw Exception('Échec de l\'inscription: ${response.body}');
    }
  }

  // Méthode pour sauvegarder le token dans le stockage local
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt', token);
  }

  // Méthode pour récupérer le token depuis le stockage local
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt'); // Retourne le token, ou null s'il n'existe pas
  }

  // Méthode pour se déconnecter
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt'); // Supprime le token du stockage local
  }

  // Autres méthodes pour gérer l'authentification peuvent être ajoutées ici
}

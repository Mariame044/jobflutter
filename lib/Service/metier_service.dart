// lib/api_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobaventure/Service/auth_service.dart';
import '../models/categorie.dart'; // Assurez-vous d'importer votre modèle Metier

class MetierService {
  final String baseUrl = 'http://localhost:8080/api/enfants'; 
  final AuthService authService; // Assurez-vous que AuthService est injecté

  MetierService(this.authService); // Constructeur pour injecter AuthService

  // Méthode pour récupérer les en-têtes
  Future<Map<String, String>> getHeaders() async {
    final token = await authService.getToken(); // Récupérer le token JWT
    return {
      'Authorization': 'Bearer $token', // Ajouter le token aux en-têtes
      'Content-Type': 'application/json',
       
    };
  }

// Basculer un métier dans les favoris (ajouter ou retirer)
  Future<void> toggleFavori(int metierId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/toggle/$metierId'),
      headers: await getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Erreur lors du basculement du favori pour le métier $metierId: ${response.statusCode} ${response.body}');
    }
  }

  // Récupérer la liste des métiers favoris
  Future<List<Metier>> getFavoris() async {
    final response = await http.get(
      Uri.parse('$baseUrl/mes-favoris'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      String utf8Body = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(utf8Body);
      return jsonData.map((metier) => Metier.fromJson(metier)).toList();
    } else {
      throw Exception(
          'Erreur lors du chargement des favoris: ${response.statusCode} ${response.body}');
    }
  }



  // Méthode pour récupérer les métiers
  Future<List<Metier>> getAllMetiers() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: await getHeaders(), // Ajoutez les en-têtes à la requête
    );

    if (response.statusCode == 200) {
      
      String utf8Body = utf8.decode(response.bodyBytes);
        List<dynamic> jsonData = json.decode(utf8Body);
      return jsonData.map((metier) => Metier.fromJson(metier)).toList();
    } else {
      throw Exception('Failed to load metiers: ${response.statusCode} ${response.body}');
    }
  }
   // Méthode pour incrémenter la vue d'un métier
  Future<void> incrementerVueMetier(int metierId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/metiers/$metierId'),
      headers: await getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to increment view for metier $metierId: ${response.statusCode} ${response.body}');
    }
  }
}


// Exemple d'affichage d'image à partir de l'URL obtenue
class ImageFromUrl extends StatelessWidget {
  final String imageUrl;

  const ImageFromUrl({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          )
        );
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return Text('Erreur lors du chargement de l\'image');
      },
    );
  }
  
}
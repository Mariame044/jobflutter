// lib/video_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video.dart';
import 'auth_service.dart';

class VideoService {
  final String baseUrl = 'http://localhost:8080/api/videos'; 
  final AuthService authService; // Assurez-vous que AuthService est injecté

  VideoService(this.authService);

  // Méthode pour récupérer les en-têtes avec le token JWT
  Future<Map<String, String>> getHeaders() async {
    final token = await authService.getToken(); // Récupérer le token JWT
    return {
      'Authorization': 'Bearer $token', // Ajouter le token aux en-têtes
      'Content-Type': 'application/json',
     
    };
  }

  Future<Video?> getVideoById(int id) async {
    final headers = await getHeaders(); // Obtenir les en-têtes avec le token
    final response = await http.get(Uri.parse('$baseUrl/regarder/$id'), headers: headers);

    if (response.statusCode == 200) {
      return Video.fromJson(json.decode(utf8.decode(response.bodyBytes))); // Décodage en UTF-8
    } else {
      throw Exception('Échec du chargement de la vidéo');
    }
  }

  // Nouvelle méthode pour récupérer toutes les vidéos
  Future<List<Video>> getAllVideos() async {
    final headers = await getHeaders(); // Obtenir les en-têtes avec le token
    final response = await http.get(Uri.parse(baseUrl), headers: headers); // Utiliser la baseUrl

    if (response.statusCode == 200) {
     List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)); // Décodage en UTF-8
        return jsonList.map((json) => Video.fromJson(json)).toList(); // Mapper le JSON à une liste de vidéos
    } else {
      throw Exception('Échec du chargement des vidéos');
    }
  }

 // Nouvelle méthode pour récupérer les vidéos par métier et tranche d'âge
  Future<List<Video>> getVideosByMetierAndAge(int metierId) async {
    final headers = await getHeaders(); // Obtenir les en-têtes avec le token
    final response = await http.get(
      Uri.parse('$baseUrl/pour-enfant/metier/$metierId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)); // Décodage en UTF-8
      return jsonList.map((json) => Video.fromJson(json)).toList(); // Mapper les vidéos
    } else {
      throw Exception('Échec du chargement des vidéos');
    }
  }

  // // Méthode pour récupérer les vidéos par métier en utilisant l'ID du métier
  // Future<List<Video>> getVideosByMetierId(int metierId) async {
  //   final headers = await getHeaders();
  //   final response = await http.get(Uri.parse('$baseUrl/metier/$metierId'), headers: headers);

  //   if (response.statusCode == 200) {
  //     List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)); // Décodage en UTF-8
  //       return jsonList.map((json) => Video.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Échec du chargement des vidéos pour le métier');
  //   }
  // }

   // Nouvelle méthode pour récupérer les vidéos par métier
 
   Future<Map<String, List<Video>>> getVideosByMetier() async {
  final List<Video> allVideos = await getAllVideos(); // Récupérer toutes les vidéos
  final Map<String, List<Video>> videosGroupedByMetier = {};

  for (Video video in allVideos) {
    // Assurez-vous que le métier a une propriété 'nom'
    String metierName = video.metier?.nom ?? 'Inconnu'; // Ajustez selon votre modèle

    // Vérifiez s'il existe déjà une entrée pour ce métier dans la carte
    if (videosGroupedByMetier.containsKey(metierName)) {
      videosGroupedByMetier[metierName]?.add(video);
    } else {
      // Sinon, créez une nouvelle liste pour ce métier
      videosGroupedByMetier[metierName] = [video];
    }
  }
  
  // Affichez les groupes pour déboguer
  print('Vidéos groupées par métier: $videosGroupedByMetier');
  
  return videosGroupedByMetier; // Retourner les vidéos regroupées par métier
}


}



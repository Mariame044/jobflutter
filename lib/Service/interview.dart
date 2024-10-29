// interview_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/interview.dart';
import 'auth_service.dart';

class InterviewService {
  final String baseUrl = 'http://localhost:8080/api/interview'; // URL de base de l'API pour les interviews
  final AuthService authService; // AuthService doit être injecté

  InterviewService(this.authService); // Constructeur avec injection de AuthService

  // Méthode pour récupérer les en-têtes avec le token JWT
  Future<Map<String, String>> getHeaders() async {
    final token = await authService.getToken(); // Récupérer le token JWT
    return {
      'Authorization': 'Bearer $token', // Ajouter le token aux en-têtes
      'Content-Type': 'application/json',
    };
  }
  Future<Interview?> getInterviewById(int id) async {
    final headers = await getHeaders(); // Obtenir les en-têtes avec le token
    final response = await http.get(Uri.parse('$baseUrl/regarder/$id'), headers: headers);

    if (response.statusCode == 200) {
      return Interview.fromJson(json.decode(utf8.decode(response.bodyBytes))); // Décodage en UTF-8
    } else {
      throw Exception('Échec du chargement de la vidéo');
    }
  }

  // Méthode pour récupérer toutes les interviews
  Future<List<Interview>> getAllInterviews() async {
    final headers = await getHeaders(); // Récupérer les en-têtes avec le token
    final response = await http.get(Uri.parse(baseUrl), headers: headers); // Envoyer une requête GET à l'URL de base

    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)); // Décodage en UTF-8
      return jsonList.map((json) => Interview.fromJson(json)).toList(); // Mapper le JSON en liste d'Interviews
    } else {
      throw Exception('Échec du chargement des interviews');
    }
  }

  // Méthode pour regrouper les interviews par métier
  Future<Map<String, List<Interview>>> getInterviewsGroupedByMetier() async {
    final List<Interview> allInterviews = await getAllInterviews(); // Récupérer toutes les interviews
    final Map<String, List<Interview>> interviewsGroupedByMetier = {};

    for (Interview interview in allInterviews) {
      String metierName = interview.metier?.nom ?? 'Inconnu'; // Utiliser 'Inconnu' si le métier est null

      if (interviewsGroupedByMetier.containsKey(metierName)) {
        interviewsGroupedByMetier[metierName]?.add(interview); // Ajouter à la liste existante
      } else {
        interviewsGroupedByMetier[metierName] = [interview]; // Créer une nouvelle liste pour ce métier
      }
    }

    return interviewsGroupedByMetier; // Retourner les interviews groupées par métier
  }
// Nouvelle méthode pour récupérer les vidéos par métier et tranche d'âge
  Future<List<Interview>> getInterviewsByMetierAndAge(int metierId) async {
    final headers = await getHeaders(); // Obtenir les en-têtes avec le token
    final response = await http.get(
      Uri.parse('$baseUrl/pour-enfant/metier/$metierId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)); // Décodage en UTF-8
      return jsonList.map((json) => Interview.fromJson(json)).toList(); // Mapper les vidéos
    } else {
      throw Exception('Échec du chargement des vidéos');
    }
  }

  // Méthode pour aplatir le Map en une liste d'Interviews
  Future<List<Interview>> getFlattenedInterviews() async {
    final Map<String, List<Interview>> groupedInterviews = await getInterviewsGroupedByMetier();

    // Aplatir le Map en une seule liste
    List<Interview> allInterviews = [];
    groupedInterviews.forEach((key, value) {
      allInterviews.addAll(value);
    });
    
    return allInterviews; // Retourner une liste d'interviews
  }
}

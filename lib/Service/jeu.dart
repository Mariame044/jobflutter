import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobaventure/Service/auth_service.dart';
import '../models/jeu.dart';

class JeuderoleService {
  final String baseUrl = 'http://localhost:8080/api/jeux';
  final AuthService authService;

  JeuderoleService(this.authService);

  // Méthode pour obtenir les en-têtes avec le token JWT
  Future<Map<String, String>> getHeaders({bool isMultipart = false}) async {
    final token = await authService.getToken();
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }

    return headers;
  }

  // Obtenir tous les jeux de rôle
  Future<List<Jeuderole>> getAllJeuxDeRole() async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Jeuderole.fromJson(item)).toList();
    } else {
      throw Exception('Échec du chargement des jeux de rôle: ${response.statusCode} - ${response.body}');
    }
  }

  // Obtenir les détails d'un jeu de rôle
  Future<Jeuderole> getJeuDeRoleDetails(int id) async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/$id'), headers: headers);

    if (response.statusCode == 200) {
      return Jeuderole.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec du chargement des détails du jeu de rôle: ${response.statusCode} - ${response.body}');
    }
  }

  // Jouer à un jeu et récupérer les questions
  Future<List<Question>> jouer(int jeuId) async {
    try {
      final headers = await getHeaders();
      final response = await http.get(Uri.parse('$baseUrl/$jeuId/jouer'), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Question.fromJson(item)).toList();
      } else {
        throw Exception('Échec du chargement des questions: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erreur dans la méthode jouer: $e'); 
      throw Exception('Échec du chargement des questions. Erreur: $e');
    }
  }

  // Vérifier la réponse d'une question
  Future<Map<String, dynamic>> verifierReponse(int jeuId, int questionId, String reponseDonnee) async {
    try {
      final headers = await getHeaders();
      final body = jsonEncode({
        'reponseDonnee': reponseDonnee,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/$jeuId/questions/$questionId/verifier'),
        headers: {
          'Content-Type': 'application/json',
          ...headers,
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        bool isCorrect = result['message'].toLowerCase().contains("correcte");
        return {
          'isCorrect': isCorrect,
          'message': result['message'],
        };
        } else if (response.statusCode == 409) { // 409 Conflict pour question déjà répondue
      return {
        'isCorrect': false,
        'message': 'Vous avez déjà répondu à cette question.', // Message personnalisé
      };
      } else {
        throw Exception('Échec de la vérification de la réponse : ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la vérification de la réponse: $e');
    }
  }

  // Calculer le score basé sur les réponses données
  Future<int> calculerScore(int jeuId, Map<int, String> reponsesDonnees) async {
    int score = 0;

    try {
      for (var entry in reponsesDonnees.entries) {
        final questionId = entry.key;
        final reponseDonnee = entry.value;

        // Utiliser la méthode verifierReponse pour vérifier si la réponse est correcte
        Map<String, dynamic> result = await verifierReponse(jeuId, questionId, reponseDonnee);
        
        if (result['isCorrect']) {
          score++; // Incrémentez le score si la réponse est correcte
        }
      }

      return score; // Retournez le score total
    } catch (e) {
      throw Exception('Erreur lors du calcul du score : $e');
    }
  }

  // Regrouper les jeux par métier
  Future<Map<String, List<Jeuderole>>> getJeuxParMetier() async {
    List<Jeuderole> jeux = await getAllJeuxDeRole();
    
    // Regroupement des jeux par métier
    Map<String, List<Jeuderole>> jeuxParMetier = {};

    for (var jeu in jeux) {
      String metierNom = jeu.metier?.nom ?? 'Sans métier';
      jeuxParMetier.putIfAbsent(metierNom, () => []).add(jeu);
    }

    return jeuxParMetier;
  }
  // Nouvelle méthode pour récupérer les vidéos par métier et tranche d'âge
  Future<List<Jeuderole>> getJeuderoleByMetierAndAge(int metierId) async {
    final headers = await getHeaders(); // Obtenir les en-têtes avec le token
    final response = await http.get(
      Uri.parse('$baseUrl/pour-enfant/metier/$metierId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)); // Décodage en UTF-8
      return jsonList.map((json) => Jeuderole.fromJson(json)).toList(); // Mapper les vidéos
    } else {
      throw Exception('Échec du chargement des vidéos');
    }
  }

}

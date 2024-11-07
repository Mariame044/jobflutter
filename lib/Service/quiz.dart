import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobaventure/Service/auth_service.dart';
import '../models/jeu.dart';


class QuizService {
  final String baseUrl = 'http://localhost:8080/api/quiz';
  final AuthService authService;

  QuizService(this.authService);

  // Méthode pour obtenir les en-têtes avec le token JWT
  Future<Map<String, String>> getHeaders() async {
    final token = await authService.getToken(); // Récupérer le token JWT
    return {
      'Authorization': 'Bearer $token', // Ajouter le token aux en-têtes
      'Content-Type': 'application/json',
       
    };
  }

  // Obtenir tous les jeux de rôle
  Future<List<Quiz>> getAllQuizzes() async { // Utilisation de QuizDto ici
    final headers = await getHeaders();
    final response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Quiz.fromJson(item)).toList(); // Utilisation de QuizDto
    } else {
      throw Exception('Échec du chargement des quizzes: ${response.statusCode} - ${response.body}');
    }
  }

  // Obtenir les détails d'un jeu de rôle
  Future<Quiz> getQuizById(int id) async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/$id'), headers: headers);

    if (response.statusCode == 200) {
      return Quiz.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec du chargement des détails du jeu de rôle: ${response.statusCode} - ${response.body}');
    }
  }

  // Créer un nouveau quiz
  Future<Quiz> createQuiz(Quiz quiz) async { // Nouvelle méthode pour créer un quiz
    final headers = await getHeaders();
    final body = jsonEncode(quiz.toJson()); // Convertir le DTO en JSON

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      return Quiz.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la création du quiz: ${response.statusCode} - ${response.body}');
    }
  }

  // Jouer à un jeu et récupérer les questions
  Future<List<Question>> jouer(int quizId) async {
    try {
      final headers = await getHeaders();
      final response = await http.get(Uri.parse('$baseUrl/$quizId/jouer'), headers: headers);

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
  Future<Map<String, dynamic>> verifierReponse(int quizId, int questionId, String reponseDonnee) async {
    try {
      final headers = await getHeaders();
      final body = jsonEncode({
        'reponseDonnee': reponseDonnee,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/$quizId/questions/$questionId/verifier'),
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
  Future<int> calculerScore(int quizId, Map<int, String> reponsesDonnees) async {
    int score = 0;

    try {
      for (var entry in reponsesDonnees.entries) {
        final questionId = entry.key;
        final reponseDonnee = entry.value;

        // Utiliser la méthode verifierReponse pour vérifier si la réponse est correcte
        Map<String, dynamic> result = await verifierReponse(quizId, questionId, reponseDonnee);
        
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
  Future<Map<String, List<Quiz>>> getQuizParMetier() async {
    List<Quiz> quiz = await getAllQuizzes(); // Changement ici pour utiliser QuizDto
    
    // Regroupement des jeux par métier
    Map<String, List<Quiz>> quizParMetier = {};

    for (var quiz in quiz) {
      String metierNom = quiz.metier?.nom ?? 'Sans métier';
      quizParMetier.putIfAbsent(metierNom, () => []).add(quiz as Quiz); // Changez ici pour ajouter au bon type
    }

    return quizParMetier;
  }

  // Nouvelle méthode pour récupérer les vidéos par métier et tranche d'âge
  Future<List<Quiz>> getQuizByMetierAndAge() async {
    final headers = await getHeaders(); // Obtenir les en-têtes avec le token
    final response = await http.get(
      Uri.parse('$baseUrl/pour-enfant'),
      headers: headers,
    );

    if (response.statusCode == 200) {
       String utf8Body = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes)); // Décodage en UTF-8
      return jsonList.map((json) => Quiz.fromJson(json)).toList(); // Mapper les vidéos
    } else {
      throw Exception('Échec du chargement des vidéos');
    }
  }

}

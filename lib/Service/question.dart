import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/jeu.dart';  // Assurez-vous que le chemin d'importation est correct

class CombinedService {
  final String baseUrlReponse = 'http://localhost:8080/api/reponse'; // Remplacez par l'URL de votre API
  final String baseUrlQuestion = 'http://localhost:8080/api/question'; // Remplacez par l'URL de votre API
  final AuthService authService;

  CombinedService({required this.authService});

  // Méthode pour obtenir les en-têtes avec le token JWT
  Future<Map<String, String>> getHeaders() async {
    final token = await authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Obtenir les détails d'une réponse
  Future<Reponse> getReponseDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrlReponse/$id'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return Reponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load response details');
    }
  }

  // Obtenir toutes les réponses
  Future<List<Reponse>> getAllReponses() async {
    final response = await http.get(
      Uri.parse(baseUrlReponse),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Reponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load responses');
    }
  }

  // Obtenir les détails d'une question
  Future<Question> getQuestionDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrlQuestion/$id'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return Question.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load question details');
    }
  }

  // Obtenir toutes les questions
  Future<List<Question>> getAllQuestions() async {
     
    final response = await http.get(
      Uri.parse(baseUrlQuestion),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
       String utf8Body = utf8.decode(response.bodyBytes);
      final List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Question.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}

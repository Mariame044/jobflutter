import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobaventure/Service/auth_service.dart';
import '../models/enfant.dart';

class ApiService {
  final String baseUrl = 'http://localhost:8080/api/parents'; // URL de base de l'API
  final AuthService authService = AuthService(); // Instanciation du service d'authentification

  // Méthode pour obtenir les en-têtes avec le token JWT
  Future<Map<String, String>> getHeaders() async {
    final token = await authService.getToken(); // Récupérer le token JWT
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  // Méthode pour assigner un enfant à un parent
Future<Enfant?> superviseEnfant(String enfantEmail) async {
  final response = await http.post(
    Uri.parse('$baseUrl/supervise-enfant/$enfantEmail'),
    headers: await getHeaders(),
    body: jsonEncode({'enfantEmail': enfantEmail}),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    return Enfant.fromJson(json); // Convertir le JSON en objet Enfant
  } else {
    final Map<String, dynamic> error = jsonDecode(response.body);
    throw Exception('Erreur: ${error['message'] ?? 'Erreur inconnue'}');
  }
}
  
  // Méthode pour obtenir la progression d'un enfant
  Future<Map<String, dynamic>> getProgressionEnfant(String enfantEmail) async {
    final response = await http.get(
      Uri.parse('$baseUrl/enfant/progression/$enfantEmail'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return json; // Retourner la progression sous forme de Map<String, dynamic>
    } else {
      final Map<String, dynamic> error = jsonDecode(response.body);
      throw Exception('Erreur: ${error['message'] ?? 'Erreur inconnue'}');
    }
  }
// Méhode pour récupérer les enfants supervisés
Future<List<Enfant>> getEnfantsByCurrentParent() async {
  final response = await http.get(
    Uri.parse('$baseUrl/getEnfantsByCurrentParent'),
    headers: await getHeaders(),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((e) => Enfant.fromJson(e)).toList();
  } else {
    throw Exception('Erreur : ${response.body}');
  }
}

}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart'; // Pour gérer l'authentification et obtenir le token JWT

class EnfantService {
  final String apiUrl = 'http://localhost:8080/api/enfants/progression';

  final AuthService authService; // Injecter le service d'authentification

  EnfantService(this.authService);

  // Méthode pour récupérer les en-têtes avec le token JWT
  Future<Map<String, String>> getHeaders() async {
    final token = await authService.getToken(); // Récupérer le token JWT
    return {
      'Authorization': 'Bearer $token', // Ajouter le token aux en-têtes
      'Content-Type': 'application/json',
    };
  }

  // Récupérer la progression de l'enfant connecté
  Future<Map<String, dynamic>> getProgression() async {
    final headers = await getHeaders();
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération de la progression de l\'enfant');
    }
  }
}

import 'dart:convert';
import 'dart:typed_data'; // Importez pour Uint8List
import 'package:http/http.dart' as http;
import '../models/RegisterUserDto.dart';
import '../Service/auth_service.dart'; 
import 'package:http_parser/http_parser.dart'; 

class ProfileService {
  final String apiUrl = 'http://localhost:8080/api/modifier'; 
  final AuthService _authService = AuthService(); 

  // Récupérer l'utilisateur connecté
  Future<Users> getCurrentUser() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return Users.fromJson(json.decode(response.body)); 
    } else {
      throw Exception('Failed to load user data');
    }
  }

  // Mettre à jour le profil de l'utilisateur
  Future<Users> updateUserProfile(
    int userId,
    String fullName,
    String password,
    String confirmPassword, {
    Uint8List? image, // Changer File? en Uint8List?
  }) async {
    var request = http.MultipartRequest('PUT', Uri.parse('$apiUrl/current'));

    // Ajouter les champs de formulaire
    request.fields['fullName'] = fullName;
    if (password.isNotEmpty) {
      request.fields['password'] = password;
    }
    if (confirmPassword.isNotEmpty) {
      request.fields['confirmPassword'] = confirmPassword;
    }

    // Vérifiez si l'image est définie avant de l'ajouter
    if (image != null) {
      // Assurez-vous de définir un nom de fichier
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        image,
        filename: 'profile_image.jpg', // Définir un nom par défaut
        contentType: MediaType('image', 'jpeg'), // Utiliser un type d'image approprié
      ));
    }

    request.headers.addAll(await _getHeaders(isMultipart: true)); 

    final response = await request.send(); 

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return Users.fromJson(json.decode(responseBody)); 
    } else {
      String responseBody = await response.stream.bytesToString();
      throw Exception('Failed to update user profile: ${responseBody}');
    }
  }

  // Méthode pour obtenir les headers
  Future<Map<String, String>> _getHeaders({bool isMultipart = false}) async {
    final token = await _authService.getToken(); 

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    if (!isMultipart) {
      headers['Content-Type'] = 'application/json'; 
    }

    return headers;
  }
}

// lib/models/register_user_dto.dart

class RegisterUserDto {
  final String nom;
  final String email;
  final String password;
  final String role;
  final int? age; // Peut être nul si le rôle est Parent
  final int tentativesRestantes; // Tentatives de réponses restantes
  final DateTime? derniereTentative; // Dernière tentative
  final bool enAttente; // Indique si l'enfant est en attente
  final int score; // Score de l'enfant, typé comme int
  final String? profession; // Peut être nul si le rôle est Enfant

  RegisterUserDto({
    required this.nom,
    required this.email,
    required this.password,
    required this.role,
    this.age,
    this.tentativesRestantes = 6, // Initialement 6 tentatives
    this.derniereTentative,
    this.enAttente = false,
    this.score = 0, // Score initial à zéro
    this.profession,
  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'email': email,
      'password': password,
      'role': role,
      'age': age,
      'tentativesRestantes': tentativesRestantes, // Ajouté
      'derniereTentative': derniereTentative?.toIso8601String(), // Format DateTime
      'enAttente': enAttente, // Ajouté
      'score': score, // Ajouté
      'profession': profession, // Ajouté
    };
  }
}


class Users {
  final int id;
  final String nom;
  final String? password; // Le mot de passe est optionnel
  final String? imageUrl; // L'URL de l'image est optionnelle

  // Constructeur
  Users({
    required this.id,
    required this.nom,
    this.password,
    this.imageUrl,
  });

  // Méthode pour créer un objet Users à partir de JSON
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] as int,
      nom: json['nom'] as String,
      password: json['password'] as String?, // Peut être nul
      imageUrl: json['imageUrl'] as String?, // Peut être nul
    );
  }

  // Méthode pour convertir un objet Users en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'password': password,
      'imageUrl': imageUrl,
    };
  }
}
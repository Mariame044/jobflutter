import 'package:jobaventure/models/interview.dart';
import 'package:jobaventure/models/video.dart';

class Role {
  final int id;
  final String nom;

  Role({required this.id, required this.nom});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      nom: json['nom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
    };
  }
}

class Parent {
  final int id;
  final String nom;
  final String email;

  Parent({required this.id, required this.nom, required this.email});

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
    };
  }
}

class Enfant {
  final int id;
  final String nom;
  final String email;
  final String password;
  final String? imageUrl;
  final Role role;
  final int? age;
  final int tentativesRestantes;
  final DateTime? derniereTentative;
  final bool enAttente;
  final List<int> questionsResolues;
  final List<Interview> interviewRegardees;
  final List<Video> videoRegardees;
  final int score;
  final Parent parent;

  Enfant({
    required this.id,
    required this.nom,
    required this.email,
    required this.password,
    this.imageUrl,
    required this.role,
    this.age,
    required this.tentativesRestantes,
    this.derniereTentative,
    required this.enAttente,
    required this.interviewRegardees,
    required this.videoRegardees,
    required this.questionsResolues,
    required this.score,
    required this.parent,
  });

  factory Enfant.fromJson(Map<String, dynamic> json) {
    return Enfant(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      password: json['password'],
      imageUrl: json['imageUrl'],
      role: Role.fromJson(json['role']),
      age: json['age'],
      tentativesRestantes: json['tentativesRestantes'] ?? 6,
      derniereTentative: json['derniereTentative'] != null
          ? DateTime.parse(json['derniereTentative'])
          : null,
      enAttente: json['enAttente'] ?? false,
       interviewRegardees: (json['interviewRegardees'] as List<dynamic>?)
              ?.map((interviewJson) => Interview.fromJson(interviewJson))
              .toList() ??
          [],
      videoRegardees: (json['videoRegardees'] as List<dynamic>?)
              ?.map((videoJson) => Video.fromJson(videoJson))
              .toList() ??
          [],
      questionsResolues: List<int>.from(json['questionsResolues'] ?? []),
      score: json['score'] ?? 0,
      parent: Parent.fromJson(json['parent']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'password': password,
      'imageUrl': imageUrl,
      'role': role.toJson(),
      'age': age,
      'tentativesRestantes': tentativesRestantes,
      'derniereTentative': derniereTentative?.toIso8601String(),
      'enAttente': enAttente,
        'interviewRegardees': interviewRegardees.map((e) => e.toJson()).toList(),
      'videoRegardees': videoRegardees.map((e) => e.toJson()).toList(),
      'questionsResolues': questionsResolues,
      'score': score,
      'parent': parent.toJson(),
    };
  }
}



class Users {
  final int id;
  final String nom;
  final String email;
  final int? age;
  final String? password; // Le mot de passe est optionnel
  final String? imageUrl; // L'URL de l'image est optionnelle

  // Constructeur
  Users({
    required this.id,
    required this.nom,
   required this.email,

    this.age,
    this.password,
    this.imageUrl,
  });

  // Méthode pour créer un objet Users à partir de JSON
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] as int,
      nom: json['nom'] as String,
      email: json['email'] as String,
      age: json['age'],
      
    
      password: json['password'] as String?, // Peut être nul
      imageUrl: json['imageUrl'] as String?, // Peut être nul
    );
  }

  // Méthode pour convertir un objet Users en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'email' : email,
      'password': password,
      'imageUrl': imageUrl,
    };
  }
}
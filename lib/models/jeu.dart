

import 'categorie.dart';

class Jeuderole {
  int? id;
  String nom; // Assurez-vous que cela ne soit jamais nul
  String description; // Assurez-vous que cela ne soit jamais nul
  Metier? metier; // Peut être nul
  String? imageUrl; // Peut être nul
   String? audioUrl; // Peut être nul

  Jeuderole({
    this.id,
    required this.nom,
    required this.description,
    this.metier,
    this.imageUrl,
    this.audioUrl,
  });

  factory Jeuderole.fromJson(Map<String, dynamic> json) {
    return Jeuderole(
      id: json['id'] as int?,
      nom: json['nom'] as String,
      description: json['description'] as String,
      metier: json['metier'] != null ? Metier.fromJson(json['metier']) : null,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'metier': metier?.toJson(),
      'imageUrl': imageUrl,
      'audioUrl' : audioUrl,
    };
  }
}

// type_question.dart
enum TypeQuestion { Quiz, JEU_DE_ROLE }

TypeQuestion typeQuestionFromString(String str) {
  switch (str) {
    case 'Quiz':
      return TypeQuestion.Quiz;
    case 'JEU_DE_ROLE':
      return TypeQuestion.JEU_DE_ROLE;
    default:
      throw Exception('Unknown TypeQuestion value');
  }
}

String typeQuestionToString(TypeQuestion type) {
  switch (type) {
    case TypeQuestion.Quiz:
      return 'Quiz';
    case TypeQuestion.JEU_DE_ROLE:
      return 'JEU_DE_ROLE';
  }
}
// reponse.dart
class Reponse {
  int? id;
  String? libelle; // Rendre libelle nullable
  List<String> reponsepossible; // Doit être une liste de chaînes
  String? correct; // Doit être une chaîne pour correspondre au modèle Java

  Reponse({
    this.id,
    this.libelle, // Rendre libelle nullable
    required this.reponsepossible,
    required this.correct,
  });

  factory Reponse.fromJson(Map<String, dynamic> json) {
    return Reponse(
      id: json['id'] as int?,
      libelle: json['libelle'] as String?, // Rendre libelle nullable
      reponsepossible: List<String>.from(json['reponsepossible'] as List),
      correct: json['correct'] as String?, // Correction : traiter correct comme une chaîne
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle,
      'reponsepossible': reponsepossible,
      'correct': correct, // Correction : traiter correct comme une chaîne
    };
  }
}


// question.dart
class Question {
  int? id; // Peut être nul
  int point; // Ne doit pas être nul
  String? texte; // Peut être nul
  TypeQuestion typeQuestion; // Ne doit pas être nul
  int? quizId; // Peut être nul
  int? jeuDeRoleId; // Peut être nul
  Reponse? reponse; // Peut être nul
  Jeuderole? jeuDeRole; // Peut être nul
  Quiz? quiz; // Peut être nul

  Question({
    this.id,
    required this.point,
    this.texte,
    required this.typeQuestion,
    this.quizId,
    this.jeuDeRoleId,
    this.reponse,
    this.jeuDeRole,
    this.quiz,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int?,
      point: json['point'] as int, // Vérifie que cela ne soit jamais nul
      texte: json['texte'] as String?, // Peut être nul
      typeQuestion: typeQuestionFromString(json['typeQuestion'] as String), // Vérifiez que ce champ ne soit pas nul
      quizId: json['quizId'] as int?,
      jeuDeRoleId: json['jeuDeRoleId'] as int?,
      reponse: json['reponse'] != null ? Reponse.fromJson(json['reponse']) : null,
      jeuDeRole: json['jeuderole'] != null ? Jeuderole.fromJson(json['jeuderole']) : null,
      quiz: json['quiz'] != null ? Quiz.fromJson(json['quiz']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'point': point,
      'texte': texte, // Peut être nul
      'typeQuestion': typeQuestionToString(typeQuestion),
      'quizId': quizId,
      'jeuDeRoleId': jeuDeRoleId,
      'reponse': reponse?.toJson(),
      'jeuderole': jeuDeRole?.toJson(),
       'quiz': quiz?.toJson(),
    };
  }
}
class Quiz {
  int? id;            // Optionnel, généré par le backend
  String titre;
  String description;
  int score;
  Metier? metier;     // Peut être de type Metier ou null
  
  // Constructeur
  Quiz({
    this.id,
    required this.titre,
    required this.description,
    required this.score,
    this.metier,
  });

  // Méthode pour convertir un objet JSON en instance de Quiz
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      score: json['score'],
      metier: json['metier'] != null ? Metier.fromJson(json['metier']) : null,
    );
  }

  // Méthode pour convertir une instance de Quiz en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'score': score,
      'metier': metier?.toJson(),
    };
  }
}
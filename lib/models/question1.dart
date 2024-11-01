import 'dart:convert';

class Question1 {
  final int? id;               // ID de la question
  final int? interviewId;     // ID de l'interview associée
  final String? emailEnfant;  // Email de l'enfant
  final String? contenu;       // Contenu de la question
  final DateTime? date;        // Date de la question

  Question1({
    this.id,
    this.interviewId,
    this.emailEnfant,
    this.contenu,
    this.date,
  });

  // Convertir un objet Question1 en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'interviewId': interviewId,
      'emailEnfant': emailEnfant,
      'contenu': contenu,
      'date': date?.toIso8601String(), // Conversion de DateTime en String
    };
  }

  // Créer un objet Question1 à partir d'une Map
  factory Question1.fromMap(Map<String, dynamic> map) {
    return Question1(
      id: map['id'],
      interviewId: map['interviewId'],
      emailEnfant: map['emailEnfant'],
      contenu: map['contenu'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null, // Conversion de String en DateTime
    );
  }

  @override
  String toString() {
    return 'Question1{id: $id, interviewId: $interviewId, emailEnfant: $emailEnfant, contenu: $contenu, date: $date}';
  }

  // Méthode pour convertir un objet Question1 en JSON
  String toJson() => json.encode(toMap());

  // Méthode pour créer un objet Question1 à partir d'une chaîne JSON
  factory Question1.fromJson(String source) => Question1.fromMap(json.decode(source));
}

// Define the Interview class


import 'categorie.dart';

class Interview {
  final int id;
  final String description;
  // final String titre;
  final String url; // URL de la vidéo
  final Metier? metier; // Can be Metier or null
  final int? nombreDeVues; // Optional property
  final DateTime? date; // Add DateTime property for date

  Interview({
    required this.id,
    required this.description,
      // required this.titre,
    required this.url,
    this.metier, // Nullable field
    this.nombreDeVues, // Optional field
    this.date, // Nullable field for date
  });

  // Factory constructor to parse from JSON (if needed)
  factory Interview.fromJson(Map<String, dynamic> json) {
    return Interview(
      id: json['id'],
      description: json['description'],
      // titre: json['titre'],
      url: json['url'],
      metier: json['metier'] != null ? Metier.fromJson(json['metier']) : null,
      nombreDeVues: json['nombreDeVues'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null, // Parse date
    );
  }

  // Method to convert the object to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
     
      'description': description,
      'url': url,
      'metier': metier?.toJson(),
      'nombreDeVues': nombreDeVues,
      'date': date?.toIso8601String(), // Format date to ISO string
    };
  }
}

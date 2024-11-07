


import 'categorie.dart';

class Video {
  final int id;
 
  
  final String description;
  final String url; // Video URL
  final Metier? metier; // Can be Metier or null
  final Trancheage? trancheage; // Tranche d'âge associée à la vidéo
  final int? nombreDeVues; // Optional property for number of views

  Video({
    required this.id,
  
   
    required this.description,
    required this.url,
    this.metier,
    this.trancheage, // Ajout de trancheage
    this.nombreDeVues,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
    
     
      description: json['description'],
      url: json['url'],
      metier: json['metier'] != null ? Metier.fromJson(json['metier']) : null,
       trancheage: json['trancheage'] != null ? Trancheage.fromJson(json['trancheage']) : null, // Ajout de trancheage
      nombreDeVues: json['nombreDeVues'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
     
      'description': description,
      'url': url,
      'metier': metier?.toJson(),
      'trancheage': trancheage?.toJson(), // Ajout de trancheage
      'nombreDeVues': nombreDeVues,
    };
  }
}
class Trancheage {
  final int id;
  final int ageMin;
  final int ageMax;
  final String description;

  Trancheage({
    required this.id,
    required this.ageMin,
    required this.ageMax,
    required this.description,
  });

  // Méthode pour créer un Trancheage à partir d'un Map (par exemple, venant d'une API)
  factory Trancheage.fromJson(Map<String, dynamic> json) {
    return Trancheage(
      id: json['id'],
      ageMin: json['ageMin'],
      ageMax: json['ageMax'],
      description: json['description'],
    );
  }

  // Méthode pour convertir un Trancheage en Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ageMin': ageMin,
      'ageMax': ageMax,
      'description': description,
    };
  }
}


import 'package:jobaventure/models/categorie.dart';

class Video {
  final int id;
  final String duree; // Duration of the video
  final String description;
  final String url; // Video URL
  final Metier? metier; // Can be Metier or null
  final int? nombreDeVues; // Optional property for number of views

  Video({
    required this.id,
    required this.duree,
    required this.description,
    required this.url,
    this.metier,
    this.nombreDeVues,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      duree: json['duree'],
      description: json['description'],
      url: json['url'],
      metier: json['metier'] != null ? Metier.fromJson(json['metier']) : null,
      nombreDeVues: json['nombreDeVues'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duree': duree,
      'description': description,
      'url': url,
      'metier': metier?.toJson(),
      'nombreDeVues': nombreDeVues,
    };
  }
}
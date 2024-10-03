// lib/models.dart

class Categorie {
  final int id;
  final String nom;

  Categorie({
    required this.id,
    required this.nom,
  });

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['id'],
      nom: json['nom'] ?? 'Catégorie non disponible', // Valeur par défaut
    );
  }
}
class Metier {
  final int id;
  final String nom;
  final String description;
   final Categorie categorie;
  final String imageUrl; // Assurez-vous que ce soit un String
  // Autres propriétés...

  Metier({
    required this.id,
    required this.nom,
    required this.description,
    required this.categorie,
    required String imageUrl,
  }) : imageUrl = imageUrl.replaceAll('\\', '/'); // Remplace les barres obliques inversées par des barres obliques




  factory Metier.fromJson(Map<String, dynamic> json) {
    return Metier(
      id: json['id'], // Assurez-vous d'inclure l'ID
      nom: json['nom'] ?? 'Nom non disponible', // Valeur par défaut
      description: json['description'] ?? 'Description non disponible', // Valeur par défaut
      imageUrl: json['imageUrl'] != null ? json['imageUrl'] : null, // Gérer null
      categorie: Categorie.fromJson(json['categorie']),
    );
  }
}

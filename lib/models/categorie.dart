class Metier {
  final int id;
  final String nom;
  final String description;
  final String? imageUrl;
  final Categorie? categorie;

  Metier({
    required this.id,
    required this.nom,
    required this.description,
    this.imageUrl,
    this.categorie,
  });

  // Convertit un objet Metier en un map (pour JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'imageUrl': imageUrl,
      'categorie': categorie?.toJson(),
    };
  }

  // Crée un objet Metier à partir d'un map (JSON)
  factory Metier.fromJson(Map<String, dynamic> json) {
    return Metier(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      categorie: json['categorie'] != null 
          ? Categorie.fromJson(json['categorie']) 
          : null,
    );
  }
}

class Categorie {
  final int id;
  final String nom;
  

  Categorie({
    required this.id,
    required this.nom,
    
  });

  // Convertit un objet Categorie en un map (pour JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
   
    };
  }

  // Crée un objet Categorie à partir d'un map (JSON)
  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['id'],
      nom: json['nom'],
    
    );
  }
}

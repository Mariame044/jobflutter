// lib/models/register_user_dto.dart

class RegisterUserDto {
  final String nom;
  final String email;
  final String password;
  final String role;
  final int? age; // Peut être nul si le rôle est Parent
  final String? profession; // Peut être nul si le rôle est Enfant

  RegisterUserDto({
    required this.nom,
    required this.email,
    required this.password,
    required this.role,
    this.age,
    this.profession,
  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'email': email,
      'password': password,
      'role': role,
      'age': age,
      'profession': profession,
    };
  }
}

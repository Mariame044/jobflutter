// lib/models/auth_model.dart

class ReqRep {
  String? email;
  String? password;
  int? statusCode;
  String? token;
  String? refreshToken;
  String? role;
  String? message;
  String? nom;
  String? prenom;
  String? expirationTime;

  ReqRep({
    this.email,
    this.password,
    this.statusCode,
    this.token,
    this.refreshToken,
    this.role,
    this.message,
    this.nom,
    this.prenom,
    this.expirationTime,
  });

  factory ReqRep.fromJson(Map<String, dynamic> json) {
    return ReqRep(
      statusCode: json['statusCode'],
      token: json['token'],
      refreshToken: json['refreshToken'],
      role: json['role'],
      message: json['message'],
      nom: json['nom'],
      prenom: json['prenom'],
      expirationTime: json['expirationTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'statusCode': statusCode,
      'token': token,
      'refreshToken': refreshToken,
      'role': role,
      'message': message,
      'nom': nom,
      'prenom': prenom,
      'expirationTime': expirationTime,
    };
  }
}

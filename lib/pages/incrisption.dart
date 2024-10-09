import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Pour des animations de chargement supplémentaires
import '../models/RegisterUserDto.dart'; // Assurez-vous que c'est correct
import '../Service/auth_service.dart'; // Assurez-vous que le chemin d'importation est correct
import 'recu.dart'; // Importez la nouvelle page de confirmation

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  String _nom = '';
  String _email = '';
  String _password = '';
  String _role = 'Enfant';
  int? _age;
  String? _profession;
  String? _message;
  bool _isLoading = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
        _message = null;
      });

      try {
        RegisterUserDto input = RegisterUserDto(
          nom: _nom,
          email: _email,
          password: _password,
          role: _role,
          age: _role == 'Enfant' ? _age : null,
          profession: _role == 'Parent' ? _profession : null,
        );

        await authService.signup(input);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignupConfirmationPage()),
        );
      } catch (e) {
        setState(() {
          _message = 'Erreur lors de l\'inscription : $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Inscription'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Retour à l'écran précédent
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _animationController.drive(CurveTween(curve: Curves.easeIn)),
                    child: Image.asset('images/logo.png', height: 200),
                  );
                },
              ),
              SizedBox(height: 30),

              Text(
                'Inscrivez-vous',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),

              Text(
                'Remplissez les champs ci-dessous pour créer votre compte.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 30),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nom',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre nom';
                        }
                        return null;
                      },
                      onSaved: (value) => _nom = value!,
                    ),
                    SizedBox(height: 10),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Veuillez entrer une adresse email valide';
                        }
                        return null;
                      },
                      onSaved: (value) => _email = value!,
                    ),
                    SizedBox(height: 10),

                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 6) {
                          return 'Le mot de passe doit comporter au moins 6 caractères';
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value!,
                    ),
                    SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: _role,
                      items: <String>['Enfant', 'Parent'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _role = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Rôle',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    SizedBox(height: 10),

                    if (_role == 'Enfant')
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Âge',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre âge';
                          }
                          return null;
                        },
                        onSaved: (value) => _age = int.tryParse(value!),
                      ),
                    if (_role == 'Parent')
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Profession',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre profession';
                          }
                          return null;
                        },
                        onSaved: (value) => _profession = value!,
                      ),
                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _signup,
                      child: _isLoading
                          ? SpinKitCircle(color: Colors.white, size: 24)
                          : Text('S\'inscrire', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    if (_message != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          _message!,
                          style: TextStyle(
                            color: _message!.startsWith('Erreur') ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

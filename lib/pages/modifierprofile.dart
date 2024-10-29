import 'dart:typed_data'; // Pour manipuler les octets des images
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Utiliser image_picker pour sélectionner des images
import '../models/RegisterUserDto.dart';
import '../Service/profile.dart';

class EditProfilePage extends StatefulWidget {
  final Users user;

  EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final ProfileService _profileService = ProfileService();
  late String _fullName;
  late String _password;
  late String _confirmPassword;
  Uint8List? _imageBytes; // Utiliser Uint8List pour stocker les octets de l'image

  @override
  void initState() {
    super.initState();
    _fullName = widget.user.nom;
    _password = '';
    _confirmPassword = '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Lire les octets de l'image sélectionnée
      setState(() async {
        _imageBytes = await pickedFile.readAsBytes();
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Appelez le service avec les octets de l'image si disponibles
        await _profileService.updateUserProfile(
          widget.user.id,
          _fullName,
          _password,
          _confirmPassword,
          image: _imageBytes, // Passez les octets à la méthode du service
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour du profil: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Construire l'URL de l'image
    String imageUrl = widget.user.imageUrl != null && widget.user.imageUrl!.isNotEmpty
        ? 'http://localhost:8080/' + widget.user.imageUrl!
        : ''; // Ne rien faire si aucune image n'est disponible

    return Scaffold(
      appBar: AppBar(title: Text('Modifier le Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _imageBytes != null
                      ? MemoryImage(_imageBytes!) // Utiliser MemoryImage pour afficher l'image sélectionnée
                      : imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null, // Afficher l'image de l'utilisateur ou rien
                  child: _imageBytes == null && imageUrl.isEmpty
                      ? Icon(Icons.person, size: 80, color: Colors.blue) // Icône par défaut si pas d'image
                      : null,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _fullName,
                decoration: InputDecoration(labelText: 'Nom complet'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
                onChanged: (value) => _fullName = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
                obscureText: true,
                onChanged: (value) => _password = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirmer le mot de passe'),
                obscureText: true,
                onChanged: (value) => _confirmPassword = value,
                validator: (value) {
                  if (value != _password) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

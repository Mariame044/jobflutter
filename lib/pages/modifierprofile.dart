import 'dart:typed_data'; // For handling image bytes
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images
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
  Uint8List? _imageBytes; // To store image bytes

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
      setState(() async {
        _imageBytes = await pickedFile.readAsBytes();
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _profileService.updateUserProfile(
          widget.user.id,
          _fullName,
          _password,
          _confirmPassword,
          image: _imageBytes,
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
    // Constructing the image URL
    String imageUrl = widget.user.imageUrl != null && widget.user.imageUrl!.isNotEmpty
        ? 'http://localhost:8080/' + widget.user.imageUrl!
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le Profil', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _imageBytes != null
                      ? MemoryImage(_imageBytes!)
                      : imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  child: _imageBytes == null && imageUrl.isEmpty
                      ? Icon(Icons.person, size: 80, color: Colors.blue)
                      : null,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: _fullName,
                decoration: InputDecoration(
                  labelText: 'Nom complet',
                  labelStyle: TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
                onChanged: (value) => _fullName = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  labelStyle: TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
                obscureText: true,
                onChanged: (value) => _password = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  labelStyle: TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Background color
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Text('Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

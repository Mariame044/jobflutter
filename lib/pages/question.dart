import 'package:flutter/material.dart';
import 'package:jobaventure/models/question1.dart';
import 'package:jobaventure/Service/interview.dart';

class PoserQuestionPage extends StatefulWidget {
  final int interviewId;
  final InterviewService interviewService;

  const PoserQuestionPage({Key? key, required this.interviewId, required this.interviewService}) : super(key: key);

  @override
  _PoserQuestionPageState createState() => _PoserQuestionPageState();
}

class _PoserQuestionPageState extends State<PoserQuestionPage> {
  final TextEditingController _questionController = TextEditingController();
  String _emailEnfant = "";
  bool _isSubmitting = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _submitQuestion() async {
    if (_questionController.text.isNotEmpty) {
      setState(() => _isSubmitting = true);

      Question1 question = Question1(
        interviewId: widget.interviewId,
        emailEnfant: _emailEnfant,
        contenu: _questionController.text,
        date: DateTime.now(),
      );

      try {
        await widget.interviewService.poserQuestion(question);
        _showSuccessDialog(); // Affiche un dialogue de confirmation
        _questionController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isSubmitting = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez entrer une question.', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Succès'),
          content: Text('Votre question a été envoyée avec succès !'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poser une Question'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Votre question",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: 'Écrivez votre question ici...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            _isSubmitting
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submitQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Soumettre',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// poser_question_page.dart
import 'package:flutter/material.dart';
import 'package:jobaventure/models/question1.dart';
import 'package:jobaventure/Service/interview.dart';

class PoserQuestionPage extends StatefulWidget {
  final int interviewId; // ID de l'interview à laquelle la question est posée
  final InterviewService interviewService; // Service d'interview pour poser la question

  const PoserQuestionPage({Key? key, required this.interviewId, required this.interviewService}) : super(key: key);

  @override
  _PoserQuestionPageState createState() => _PoserQuestionPageState();
}

class _PoserQuestionPageState extends State<PoserQuestionPage> {
  final TextEditingController _questionController = TextEditingController();
  String _emailEnfant = ""; // Ici, vous pouvez récupérer l'email de l'enfant si nécessaire

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _submitQuestion() async {
    if (_questionController.text.isNotEmpty) {
      Question1 question = Question1(
        interviewId: widget.interviewId,
        emailEnfant: _emailEnfant, // Utilisez l'email de l'enfant
        contenu: _questionController.text,
        date: DateTime.now(),
      );

      try {
        await widget.interviewService.poserQuestion(question);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Question posée avec succès !'),
        ));
        _questionController.clear(); // Effacer le champ de texte
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur lors de la pose de la question : $e'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Veuillez entrer une question.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poser une Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Votre question',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitQuestion,
              child: Text('Soumettre'),
            ),
          ],
        ),
      ),
    );
  }
}

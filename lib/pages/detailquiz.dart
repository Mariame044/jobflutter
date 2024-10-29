import 'package:flutter/material.dart';
import 'package:jobaventure/Service/quiz.dart';
import 'package:jobaventure/models/jeu.dart';
import 'package:jobaventure/Service/jeu.dart';

class DetailQuizPage extends StatefulWidget {
  final int quizId;
  final QuizService quizService;

  const DetailQuizPage({Key? key, required this.quizId, required this.quizService}) : super(key: key);

  @override
  _DetailQuizPageState createState() => _DetailQuizPageState();
}

class _DetailQuizPageState extends State<DetailQuizPage> {
  late Future<List<Question>> futureQuestions;
  late Future<Quiz> futureQuiz; // Renamed to match the model
  Map<int, String?> selectedAnswers = {};
  int currentQuestionIndex = 0;
  int score = 0;
  Set<int> answeredQuestions = {}; // To track answered questions

  @override
  void initState() {
    super.initState();
    futureQuestions = widget.quizService.jouer(widget.quizId);
    futureQuiz = widget.quizService.getQuizById(widget.quizId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détails du Quiz')),
      body: FutureBuilder<Quiz>(
        future: futureQuiz,
        builder: (context, quizSnapshot) {
          if (quizSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (quizSnapshot.hasError) {
            return Center(child: Text('Erreur: ${quizSnapshot.error}'));
          } else if (!quizSnapshot.hasData) {
            return Center(child: Text('Détails du quiz non disponibles.'));
          }

          final quiz = quizSnapshot.data!;

          return Column(
            children: [
             
              Text(
                quiz.titre,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
               Text(
                quiz.description,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Display the current score
              Text(
                'Score de l\'enfant: $score',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              SizedBox(height: 10),
              FutureBuilder<List<Question>>(
                future: futureQuestions,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucune question disponible.'));
                  }

                  final questions = snapshot.data!;

                  // Check if the index is within range
                  if (currentQuestionIndex >= questions.length) {
                    return Center(child: Text('Toutes les questions ont été traitées.'));
                  }

                  final currentQuestion = questions[currentQuestionIndex];

                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              currentQuestion.texte ?? 'Question non disponible',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: currentQuestion.reponse?.reponsepossible.length ?? 0,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(currentQuestion.reponse!.reponsepossible[index]),
                                leading: Radio<String?>( // Champ radio pour chaque réponse
                                  value: currentQuestion.reponse!.reponsepossible[index],
                                  groupValue: selectedAnswers[currentQuestion.id],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAnswers[currentQuestion.id!] = value; // Stocker la réponse sélectionnée
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Vérifiez si la réponse a été sélectionnée
                              if (selectedAnswers[currentQuestion.id!] == null) {
                                _afficherDialog('Erreur', 'Veuillez sélectionner une réponse avant de continuer.');
                                return; // Ne pas continuer si aucune réponse n'est sélectionnée
                              }
                              await verifierReponseEtPasserSuivant(currentQuestionIndex, questions);
                            },
                            child: Text(currentQuestionIndex < questions.length - 1 ? 'Suivant' : 'Terminer'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> verifierReponseEtPasserSuivant(int questionIndex, List<Question> questions) async {
    try {
      // Obtenez la réponse donnée par l'utilisateur
      String reponseDonnee = selectedAnswers[questions[questionIndex].id!] ?? '';
      String? reponseCorrecte = questions[questionIndex].reponse!.correct;  // Obtenez la réponse correcte
       // Vérifiez si la question a déjà été répondue
       
 
   

      // Vérifiez si la réponse donnée est correcte
      Map<String, dynamic> result = await widget.quizService.verifierReponse(widget.quizId, questions[questionIndex].id!, reponseDonnee);
    
      if (reponseDonnee == reponseCorrecte) {
        score++; // Incrémentez le score si la réponse est correcte
        answeredQuestions.add(questions[questionIndex].id!); // Marquez la question comme répondue
        _afficherDialog('Réponse correcte', 'Bonne réponse ! Vous avez gagné un point.');

        // Passez à la question suivante
        setState(() {
          currentQuestionIndex++;
        });
      } else {
        // Si la réponse est incorrecte, afficher un message et ne pas changer la question
        _afficherDialog('Réponse incorrecte', 'Votre réponse est incorrecte, veuillez essayer à nouveau.');
      }
     
      // Si toutes les questions sont répondues, affichez le score
      if (currentQuestionIndex >= questions.length) {
        await calculerScore(questions);
      }
     if (answeredQuestions.contains(questions[questionIndex].id)) {
     
      _afficherDialog('Erreur', 'Vous avez déjà répondu à cette question.');
      return; // Ne pas continuer si la question a déjà été répondue
    }

    } catch (error) {
      _afficherDialog('Erreur', 'Une erreur est survenue : $error');
      print(error); // Afficher l'erreur dans la console pour le débogage
    }
  }

  Future<void> calculerScore(List<Question> questions) async {
    // Utilisez le score accumulé
    _afficherDialog('Score', 'Votre score est : $score');
  }

  void _afficherDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

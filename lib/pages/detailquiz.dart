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
  late Future<Quiz> futureQuiz;
  Map<int, String?> selectedAnswers = {};
  int currentQuestionIndex = 0;
  int score = 0;
  Set<int> answeredQuestions = {};
  String messageFeedback = '';
  Color couleurFeedback = Colors.transparent;
  bool afficherReponseCorrecte = false;

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
            mainAxisAlignment: MainAxisAlignment.center, // Centre les éléments verticalement
            mainAxisSize: MainAxisSize.max, // Utilise toute la hauteur disponible
            crossAxisAlignment: CrossAxisAlignment.center, // Centre les éléments horizontalement
            children: [
              Text(
                quiz.titre,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
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

                  if (currentQuestionIndex >= questions.length) {
                    return Center(child: Text('Toutes les questions ont été traitées.'));
                  }

                  final currentQuestion = questions[currentQuestionIndex];
                  final reponseCorrecte = currentQuestion.reponse?.correct;

                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.cyan[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              currentQuestion.texte ?? 'Question non disponible',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: currentQuestion.reponse?.reponsepossible.length ?? 0,
                            itemBuilder: (context, index) {
                              final option = currentQuestion.reponse!.reponsepossible[index];
                              final estSelectionnee = selectedAnswers[currentQuestion.id] == option;
                              final estCorrecte = option == reponseCorrecte;

                              Color couleurOption = Colors.grey[300]!;
                              if (afficherReponseCorrecte) {
                                couleurOption = estCorrecte
                                    ? Colors.green
                                    : (estSelectionnee ? Colors.red : Colors.grey[300]!);
                              } else if (estSelectionnee) {
                                couleurOption = Colors.blue;
                              }

                              return GestureDetector(
                                onTap: () {
                                  if (!afficherReponseCorrecte) {
                                    setState(() {
                                      selectedAnswers[currentQuestion.id!] = option;
                                      messageFeedback = '';
                                      couleurFeedback = Colors.transparent;
                                    });
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: couleurOption,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          if (messageFeedback.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                messageFeedback,
                                style: TextStyle(color: couleurFeedback, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ElevatedButton(
                            onPressed: () async {
                              if (selectedAnswers[currentQuestion.id!] == null) {
                                _afficherDialog('Erreur', 'Veuillez sélectionner une réponse avant de continuer.');
                                return;
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
      String reponseDonnee = selectedAnswers[questions[questionIndex].id!] ?? '';
      String? reponseCorrecte = questions[questionIndex].reponse!.correct;

      Map<String, dynamic> result = await widget.quizService.verifierReponse(
        widget.quizId,
        questions[questionIndex].id!,
        reponseDonnee,
      );

      setState(() {
        if (reponseDonnee == reponseCorrecte) {
          score++;
          messageFeedback = 'Bonne réponse !';
          couleurFeedback = Colors.green;
          currentQuestionIndex++;
        } else {
          messageFeedback = 'Mauvaise réponse.';
          couleurFeedback = Colors.red;
        }

        afficherReponseCorrecte = true;

        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            afficherReponseCorrecte = false;
            messageFeedback = '';
            couleurFeedback = Colors.transparent;
            currentQuestionIndex++;

            if (currentQuestionIndex >= questions.length) {
              calculerScore(questions);
            }
          });
        });
      });
    } catch (error) {
      _afficherDialog('Erreur', 'Une erreur est survenue : $error');
    }
  }

  Future<void> calculerScore(List<Question> questions) async {
    _afficherDialog('Score', 'Votre score est : $score');
  }

  void _afficherDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: Colors.deepPurple)),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.deepPurple)),
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

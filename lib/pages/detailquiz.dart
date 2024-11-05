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
  String messageFeedback = '';
  Color couleurFeedback = Colors.transparent;
  bool afficherReponseCorrecte = false;
  int questionsAnswered = 0; // Compteur pour le nombre de questions répondues

  @override
  void initState() {
    super.initState();
    futureQuestions = widget.quizService.jouer(widget.quizId);
    futureQuiz = widget.quizService.getQuizById(widget.quizId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Quiz', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  quiz.titre,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
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
                    final totalQuestions = questions.length;

                    if (currentQuestionIndex >= totalQuestions) {
                      return Center(child: Text('Toutes les questions ont été traitées.'));
                    }

                    final currentQuestion = questions[currentQuestionIndex];
                    final reponseCorrecte = currentQuestion.reponse?.correct;

                    return Expanded(
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.teal[100],
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(2, 2),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    currentQuestion.texte ?? 'Question non disponible',
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                                      couleurOption = Colors.blueAccent;
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
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: couleurOption,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(1, 1),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
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
                                      style: TextStyle(color: couleurFeedback, fontSize: 18, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (selectedAnswers[currentQuestion.id!] == null) {
                                      _afficherDialog('Erreur', 'Veuillez sélectionner une réponse avant de continuer.');
                                      return;
                                    }
                                    await verifierReponseEtPasserSuivant(currentQuestionIndex, questions);
                                  },
                                  child: Text(
                                    currentQuestionIndex < totalQuestions - 1 ? 'Suivant' : 'Terminer',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Text(
                              'Q${currentQuestionIndex + 1}/$totalQuestions',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
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
        // Incrémentez le compteur de questions répondues
        questionsAnswered++;

        if (reponseDonnee == reponseCorrecte) {
          score++;
          messageFeedback = 'Bonne réponse !';
          couleurFeedback = Colors.green;
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
    // Vérifiez si l'utilisateur a répondu à 8 questions ou plus
    if (questionsAnswered >= 8) {
      _afficherDialog('Félicitations !', 'Vous avez reçu un badge pour avoir répondu à au moins 8 questions.');
    }

    // Affichez le score final
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

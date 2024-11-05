import 'package:flutter/material.dart';
import 'package:jobaventure/models/jeu.dart';
import 'package:jobaventure/Service/jeu.dart';
import 'package:audioplayers/audioplayers.dart';

class DetailJeuPage extends StatefulWidget {
  final int jeuId;
  final JeuderoleService jeuderoleService;

  const DetailJeuPage({Key? key, required this.jeuId, required this.jeuderoleService}) : super(key: key);

  @override
  _DetailJeuPageState createState() => _DetailJeuPageState();
}

class _DetailJeuPageState extends State<DetailJeuPage> {
  late Future<List<Question>> futureQuestions;
  late Future<Jeuderole> futureJeu;
  Map<int, String?> selectedAnswers = {};
  int currentQuestionIndex = 0;
  int score = 0;
  Set<int> answeredQuestions = {};
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false; // Pour suivre l'état de lecture

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureQuestions = widget.jeuderoleService.jouer(widget.jeuId);
    futureJeu = widget.jeuderoleService.getJeuDeRoleDetails(widget.jeuId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Jeu'),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<Jeuderole>(
        future: futureJeu,
        builder: (context, jeuSnapshot) {
          if (jeuSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (jeuSnapshot.hasError) {
            return Center(child: Text('Erreur: ${jeuSnapshot.error}'));
          } else if (!jeuSnapshot.hasData) {
            return Center(child: Text('Détails du jeu non disponibles.'));
          }

          final jeu = jeuSnapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      Image.network(
                        'http://localhost:8080/${jeu.imageUrl}',
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          jeu.nom,
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                        ),
                      ),
                     IconButton(
  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
  onPressed: () async {
    String? audioUrl = jeu.audioUrl;
    if (audioUrl == null) {
      _afficherDialog('Erreur', 'L\'URL audio n\'est pas disponible.');
      return;
    }

    // Sanitize URL and use test URL if necessary
    final sanitizedUrl = Uri.parse('http://localhost:8080/${jeu.audioUrl?.replaceAll(r'\', '/')}').toString();
    final urlSource = UrlSource(sanitizedUrl);

    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      try {
        await audioPlayer.play(urlSource);
      } catch (e) {
        _afficherDialog('Erreur', 'Impossible de lire l\'audio : $e');
      }
    }

    setState(() {
      isPlaying = !isPlaying;
    });
  },
),

                    ],
                  ),
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

                    if (currentQuestionIndex >= questions.length) {
                      return Center(child: Text('Toutes les questions ont été traitées.'));
                    }

                    final currentQuestion = questions[currentQuestionIndex];

                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              currentQuestion.texte ?? 'Question non disponible',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: currentQuestion.reponse?.reponsepossible.length ?? 0,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(currentQuestion.reponse!.reponsepossible[index]),
                                  leading: Checkbox(
                                    value: selectedAnswers[currentQuestion.id] == currentQuestion.reponse!.reponsepossible[index],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAnswers[currentQuestion.id!] = value! ? currentQuestion.reponse!.reponsepossible[index] : null;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6200EE),
                                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: () async {
                                if (selectedAnswers[currentQuestion.id!] == null) {
                                  _afficherDialog('Erreur', 'Veuillez sélectionner une réponse avant de continuer.');
                                  return;
                                }
                                await verifierReponseEtPasserSuivant(currentQuestionIndex, questions);
                              },
                              child: Text(currentQuestionIndex < questions.length - 1 ? 'Suivant' : 'Terminer', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
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

      Map<String, dynamic> result = await widget.jeuderoleService.verifierReponse(widget.jeuId, questions[questionIndex].id!, reponseDonnee);
    
      if (reponseDonnee == reponseCorrecte) {
        score++;
        answeredQuestions.add(questions[questionIndex].id!);
        _afficherDialog('Réponse correcte', 'Bonne réponse ! Vous avez gagné un point.');

        setState(() {
          currentQuestionIndex++;
        });
      } else {
        _afficherDialog('Réponse incorrecte', 'Votre réponse est incorrecte, veuillez essayer à nouveau.');
      }

      if (currentQuestionIndex >= questions.length) {
        await calculerScore(questions);
      }

    } catch (error) {
      _afficherDialog('Erreur', 'Une erreur est survenue : $error');
      print(error);
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

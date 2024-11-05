import 'package:flutter/material.dart';
import 'package:jobaventure/Service/quiz.dart';
import 'package:jobaventure/models/categorie.dart';
import 'package:jobaventure/pages/detailquiz.dart';
import '../models/jeu.dart';

class QuizParMetierPage extends StatefulWidget {
  final QuizService quizService;

  QuizParMetierPage({
    Key? key,
    required this.quizService,
  }) : super(key: key);

  @override
  _QuizParMetierPageState createState() => _QuizParMetierPageState();
}

class _QuizParMetierPageState extends State<QuizParMetierPage> {
  Map<String, List<Quiz>> quizParMetier = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadQuizParMetier();
  }

  Future<void> _loadQuizParMetier() async {
    try {
      List<Quiz>? quizzes = await widget.quizService.getQuizByMetierAndAge();
      if (quizzes != null) {
        quizParMetier = {};
        for (var quiz in quizzes) {
          String metierNom = quiz.metier?.nom ?? 'Sans métier';
          quizParMetier.putIfAbsent(metierNom, () => []).add(quiz);
        }
      } else {
        errorMessage = "Aucun quiz trouvé pour ce métier.";
      }
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Erreur lors du chargement des jeux de rôle par métier: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/images/d.png',
            width: 30,
            height: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF036A94), Color(0xFF0FA3B1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'QUIZ',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(child: Text(errorMessage!))
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.builder(
                          itemCount: quizParMetier.keys.length,
                          itemBuilder: (context, index) {
                            String metier = quizParMetier.keys.elementAt(index);
                            List<Quiz> quizzes = quizParMetier[metier]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                                  child: Text(
                                    metier,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Color(0xFF0FA3B1),
                                    ),
                                  ),
                                ),
                                GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                    childAspectRatio: 3.5,
                                  ),
                                  itemCount: quizzes.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, quizIndex) {
                                    Quiz quiz = quizzes[quizIndex];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailQuizPage(
                                              quizId: quiz.id!,
                                              quizService: widget.quizService,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.quiz,
                                                size: 48,
                                                color: Color(0xFF036A94),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      quiz.titre,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18.0,
                                                        color: Color(0xFF036A94),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    const SizedBox(height: 4.0),
                                                    Text(
                                                      quiz.description,
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.grey[700],
                                                      ),
                                                      textAlign: TextAlign.left,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 18,
                                                color: Color(0xFF0FA3B1),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

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
      // Assurez-vous que getQuizByMetierAndAge est correctement défini dans QuizService
      List<Quiz>? quizzes = await widget.quizService.getQuizByMetierAndAge();

      // Vérifiez si quizzes n'est pas nul
      if (quizzes != null) {
        // Regroupement des quizzes par métier
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          SizedBox(height: 30),
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF036A94),
              ),
              child: Center(
                child: Text(
                  'QUIZ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(child: Text(errorMessage!))
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: quizParMetier.keys.length,
                          itemBuilder: (context, index) {
                            String metier = quizParMetier.keys.elementAt(index);
                            List<Quiz> quizzes = quizParMetier[metier]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    metier,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
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
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.quiz,
                                                size: 50,
                                                color: Color(0xFF036A94),
                                              ),
                                              SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      quiz.titre,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16.0,
                                                        color: Color(0xFF036A94),
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    SizedBox(height: 4.0),
                                                    Text(
                                                      quiz.description,
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.grey[600],
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
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

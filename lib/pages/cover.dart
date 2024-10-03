import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'login.dart'; // Import de la page de connexion

class CoverPage extends StatefulWidget {
  @override
  _CoverPageState createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialisation de l'AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Animation pour le logo
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Démarre l'animation
    _controller.forward();

    // Délai avant de naviguer vers la page de connexion
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 8), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
      });
    });

    // Démarrer l'affichage des métiers après la page de couverture
    Future.delayed(Duration(seconds: 10), () {
      _navigateToJobPage(0); // Démarrer avec la première page de métier
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Fonction pour naviguer vers la page de métier
  void _navigateToJobPage(int jobIndex) {
    if (jobIndex < 3) { // Assurez-vous que vous avez trois métiers
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginPage(),
      ));
    } else {
      // Si tous les métiers ont été affichés, retournez à la page de connexion
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginPage(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Stack(
            children: [
              // Fond coloré avec dégradé
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Contenu principal
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo avec animation
                  AnimatedContainer(
                    duration: Duration(seconds: 2),
                    curve: Curves.bounceIn,
                    child: Image.asset('images/logo.png', width: 200), // Remplacez par votre logo
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Job Aventure',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  // Texte d'encouragement
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Ose rêver grand ! Avec "Job aventure", tu as la chance d\'explorer des carrières passionnantes et de comprendre ce que signifie vraiment chaque métier. Ensemble, faisons de ton rêve une réalité !',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ),
                  SizedBox(height: 40),
                  // Bouton de démarrage
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                    },
                    child: Text("Commencer", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
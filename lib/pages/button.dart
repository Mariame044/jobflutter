import 'package:flutter/material.dart';
import 'package:jobaventure/Service/interview.dart';
import 'package:jobaventure/Service/jeu.dart';
import 'package:jobaventure/Service/video.dart';
import 'package:jobaventure/models/categorie.dart';
import 'package:jobaventure/pages/interviewparmetier.dart';
import 'package:jobaventure/pages/jeuparmetier.dart';
import 'package:jobaventure/pages/videoparmetier.dart';

class CategoryButtons extends StatelessWidget {
  final Metier metier;
  final InterviewService interviewService;
  final VideoService videoService;
  final JeuderoleService jeuderoleService;

  const CategoryButtons({
    Key? key,
    required this.metier,
    required this.interviewService,
    required this.videoService,
    required this.jeuderoleService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      child: Wrap(
        spacing: 20.0,
        runSpacing: 20.0,
        alignment: WrapAlignment.center,
        children: [
          _buildButton(
            context: context,
            label: 'Vidéo',
            color: const Color(0xFF00BFFF),
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupedVideosScreen(
                    metier: metier,
                    videoService: videoService,
                    jeuderoleService: jeuderoleService,
                    interviewService: interviewService,
                  ),
                ),
              );
            },
          ),
          _buildButton(
            context: context,
            label: 'Jeux',
            color: const Color(0xFFB0BEC5),
            textColor: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JeuxParMetierPage(
                    metier: metier,
                    jeuderoleService: jeuderoleService, interviewService: interviewService, videoService: videoService
                  ),
                ),
              );
            },
          ),
          _buildButton(
            context: context,
            label: 'Interviews',
            color: const Color(0xFF8BC34A),
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InterviewsByMetierPage(
                  jeuderoleService: jeuderoleService,
                  interviewService: interviewService,
                  videoService: videoService,
                  metier: metier,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 16, color: textColor),
      ),
    );
  }
}

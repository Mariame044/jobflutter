import 'package:flutter/material.dart';
import 'package:jobaventure/Service/auth_service.dart';
import 'package:jobaventure/pages/detailvideo.dart';
import '../models/video.dart';
import '../Service/video.dart'; // Assurez-vous que le chemin d'importation est correct

class GroupedVideosScreen extends StatefulWidget {
  @override
  _GroupedVideosScreenState createState() => _GroupedVideosScreenState();
}

class _GroupedVideosScreenState extends State<GroupedVideosScreen> {
  final VideoService videoService = VideoService(AuthService());
  Map<String, List<Video>> groupedVideos = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGroupedVideos();
  }

  Future<void> fetchGroupedVideos() async {
    try {
      // Récupérer toutes les vidéos
      List<Video> allVideos = await videoService.getAllVideos();

      // Grouper les vidéos par métier
      for (var video in allVideos) {
        String metierNom = video.metier?.nom ?? "Inconnu"; // Utiliser "Inconnu" si le métier est null
        if (groupedVideos[metierNom] == null) {
          groupedVideos[metierNom] = [];
        }
        groupedVideos[metierNom]!.add(video);
      }
    } catch (e) {
      print('Erreur lors du chargement des vidéos: $e');
    } finally {
      setState(() {
        isLoading = false; // Changer l'état une fois que les vidéos sont chargées
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vidéos par Métier'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: groupedVideos.keys.length,
              itemBuilder: (context, index) {
                String metierNom = groupedVideos.keys.elementAt(index);
                List<Video> videoList = groupedVideos[metierNom]!;

                return ExpansionTile(
                  title: Text(metierNom),
                  children: videoList.map((video) {
                    return ListTile(
                      title: Text(video.description),
                      onTap: () {
                        // Naviguer vers l'écran de lecture de la vidéo
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoDetailScreen(video: video),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:social_network/service/storage.dart';
import 'dart:convert';

import 'Home.dart';

class CategoryPage extends StatelessWidget {
   final List<Map<String, dynamic>> hobbies = [
    { 'id': 1, 'label': 'Cuisine', 'imgurl': 'https://images.unsplash.com/photo-1484980972926-edee96e0960d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y3Vpc2luZXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=600&q=60' },
    { 'id': 2, 'label': 'Couture', 'imgurl': 'https://images.unsplash.com/photo-1594205354876-7930d557a78c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y291dHVyZXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=600&q=60' },
    { 'id': 3, 'label': 'Cyclisme', 'imgurl': 'https://images.unsplash.com/photo-1578345728913-ce0d20741dc0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y3ljbGlzbWV8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=600&q=60' },
    { 'id': 4, 'label': 'Danse', 'imgurl': 'https://images.unsplash.com/photo-1590673740213-3fdd8ea14f5b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZGFuc2V8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=600&q=60' },
    { 'id': 5, 'label': 'Dessin', 'imgurl': 'https://images.unsplash.com/photo-1630257574179-966315085420?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZGVzc2lufGVufDB8fDB8fHww&auto=format&fit=crop&w=600&q=60' },
    { 'id': 6, 'label': 'Gastronomie', 'imgurl': 'https://images.unsplash.com/photo-1499715217757-2aa48ed7e593?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Z2FzdHJvbm9teXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=600&q=60' },
    { 'id': 7, 'label': 'Restaurant','imgurl': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=600&q=60'},
    { 'id': 8, 'label': 'Bar', 'imgurl': 'https://images.unsplash.com/photo-1525268323446-0505b6fe7778?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YmFyfGVufDB8fDB8fHww&auto=format&fit=crop&w=600&q=60' },
    { 'id': 9, 'label': 'Café', 'imgurl': 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y2FmZXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=600&q=60' },
    { 'id': 10, 'label': 'Jardinage', 'imgurl': 'https://images.unsplash.com/photo-1606502428410-d36c8cbff701?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8amFyZGluYWdlfGVufDB8fDB8fHww&auto=format&fit=crop&w=600&q=60' },
    { 'id': 11, 'label': 'Jeux de société', 'imgurl': 'https://images.unsplash.com/photo-1676494096198-5d2eb620cdb7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8amV1JTIwZCclQzMlQTljaGVjfGVufDB8fDB8fHww&auto=format&fit=crop&w=600&q=60' },
    { 'id': 12, 'label': 'Jeux vidéo', 'imgurl': 'https://images.unsplash.com/photo-1493711662062-fa541adb3fc8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dmlkZW8lMjBnYW1lfGVufDB8fDB8fHww&auto=format&fit=crop&w=600&q=60' },
    { 'id': 13, 'label': 'Lecture', 'imgurl': 'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cmVhZGluZ3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=600&q=60' },
    { 'id': 14, 'label': 'Musique', 'imgurl': 'https://images.unsplash.com/photo-1528643609128-c50fdc20cc58?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8YWZyb2JlYXR8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=600&q=60' },
    { 'id': 15, 'label': 'Peinture', 'imgurl': 'https://images.unsplash.com/photo-1510832842230-87253f48d74f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cGFpbnRpbmd8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=600&q=60' },
    { 'id': 16, 'label': 'Photographie', 'imgurl': 'https://images.unsplash.com/photo-1609607847926-da4702f01fef?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fHBob3RvfGVufDB8fDB8fHww&auto=format&fit=crop&w=600&q=60' },
    { 'id': 17, 'label': 'Robotique', 'imgurl': 'https://images.unsplash.com/photo-1589254065909-b7086229d08c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8cm9ib3R8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=600&q=60' },
    { 'id': 18, 'label': 'Sciences', 'imgurl': 'https://images.unsplash.com/photo-1564325724739-bae0bd08762c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8c2NpZW5jZSUyMGFuZCUyMHRlY2hub2xvZ3l8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=600&q=60' },
    { 'id': 19, 'label': 'Sport', 'imgurl': 'https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHNwb3J0fGVufDB8fDB8fHww&auto=format&fit=crop&w=600&q=60'},
    { 'id': 20, 'label': 'Voyage', 'imgurl': 'https://images.unsplash.com/photo-1567009694991-c26bee6f79ae?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8dm95YWdlfGVufDB8fDB8fHww&auto=format&fit=crop&w=600&q=60'},
    { 'id': 21, 'label': 'Yoga', 'imgurl': 'https://images.unsplash.com/photo-1593810451137-5dc55105dace?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHlvZ2F8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=600&q=60'},
    { 'id': 22, 'label': 'Autre', 'imgurl':'https://images.unsplash.com/photo-1470790376778-a9fbc86d70e2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8b3RoZXJ8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=600&q=60'},
];

 

  void showEventsPopup(BuildContext context, List<dynamic> events) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Événements associés'),
          content: Column(
            children: events.map((event) {
              final title = event['nom'];
              final description = event['description'];
              final price = event['prix'];

              return ListTile(
                title: Text(title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(description),
                    Text('Prix: $price €'),
                  ],
                ),
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchEventsByHobby(BuildContext context, String hobbylabel) async {
     StorageService storageService = StorageService();
     String? token = await storageService.readSecureData('token');

    final url = 'http://localhost:3000/api/v1/event/hobby/$hobbylabel';
    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final events = jsonData['events'];

      
      showEventsPopup(context, events);
    } else {
      // Gérer les erreurs de requête ici
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur de requête'),
            content: Text('Une erreur s\'est produite lors de la récupération des événements.'),
            actions: <Widget>[
              TextButton(
                child: Text('Fermer'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: hobbies.length,
        itemBuilder: (context, index) {
          final hobby = hobbies[index];

          return GestureDetector(
            onTap: () {
              fetchEventsByHobby(context, hobby['label'].toString());
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(
                      hobby['imgurl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      hobby['label'],
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

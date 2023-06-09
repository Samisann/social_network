import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/Hobby.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  List<Hobby> hobbies = [];

  @override
  void initState() {
    super.initState();
    fetchHobbies().then((hobbiesList) {
      setState(() {
        hobbies = hobbiesList;
      });
    });
  }

  Future<List<Hobby>> fetchHobbies() async {
    const apiUrl = 'http://localhost:3000/api/hobbies';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final hobbies = data
            .map((item) => Hobby(id: item['_id'], label: item['label']))
            .toList();

        print('Hobbies retrieved successfully');
        print(hobbies);

        return hobbies;
      } else {
        print('Failed to retrieve hobbies. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while retrieving hobbies: $e');
    }

    return []; 
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController lieuController = TextEditingController();
  Hobby? selectedHobby;

  Future<void> createEvent() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // Récupérez les valeurs des champs du formulaire
      String eventName = eventNameController.text;
      String email = emailController.text;
      String description = descriptionController.text;
      String date = dateController.text;
      String lieuLat = lieuController.text; 
      String lieuLong = '';

      
      Map<String, dynamic> requestBody = {
        'eventName': eventName,
        'email': email,
        'description': description,
        'date': date,
        'lieu': {
    'lat': lieuLat,
    'long': lieuLong,
  },
        'hobby': selectedHobby!.label,
      };

      
      const apiUrl = 'http://localhost:3000/api/v1/user/event'; 
      final response = await http.post(Uri.parse(apiUrl), body: jsonEncode(requestBody));

 
      if (response.statusCode == 200) {
        
        print('Événement créé avec succès');
        
      } else {
        
        print('Échec de la création de lévénement. Code de statut : ${response.statusCode}');
      }
    }
  }

  @override
  void dispose() {
    eventNameController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    lieuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un événement'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: eventNameController,
                decoration: InputDecoration(labelText: 'Nom de l\'événement'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le nom de l\'événement';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir votre email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir la description de l\'événement';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir la date de l\'événement';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lieuController,
                decoration: InputDecoration(labelText: 'Lieu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le lieu de l\'événement';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Hobby>(
                decoration: InputDecoration(labelText: 'Hobbies'),
                value: selectedHobby,
                items: hobbies.map((Hobby hobby) {
                  return DropdownMenuItem<Hobby>(
                    value: hobby,
                    child: Text(hobby.label),
                  );
                }).toList(),
                onChanged: (Hobby? value) {
                  setState(() {
                    selectedHobby = value;
                  });
                },
                validator: (Hobby? value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un hobby';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: createEvent,
                child: Text('Créer un événement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

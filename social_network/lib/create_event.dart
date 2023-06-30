import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:social_network/service/storage.dart';
import 'models/Hobby.dart';
import 'home.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  List<Hobby> hobbies = [];
  final StorageService _storageService = StorageService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController lieuController = TextEditingController();
  Hobby? selectedHobby;

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

  Future<void> createEvent() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // Get the values from the form fields
      String eventName = eventNameController.text;
      String description = descriptionController.text;
      String date = dateController.text;
      String lieuLat = lieuController.text;
      String lieuLong = '';

      // Get the email from the token
      final token = await _storageService.readSecureData("token");
      final email = JwtDecoder.decode(token!)['username'];

      // Create the request body
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
        // Display success dialogue
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Succès'),
              content: Text('L\'événement a été créé avec succès'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    // Redirect to Home page
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Échec de la création de l\'événement. Code de statut : ${response.statusCode}');
      }
    }
  }

  @override
  void dispose() {
    eventNameController.dispose();
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
         leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );})
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

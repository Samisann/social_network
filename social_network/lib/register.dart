import 'package:flutter/material.dart';
import 'package:social_network/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:social_network/service/storage.dart';

import 'package:social_network/models/Hobby.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = StorageService();
  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _email = '';
  String _password = '';
  List<String> _hobbies = [];

  List<Hobby> hobbies = [];

  // Navigate to the next page
  void _nextPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => page));
  }

  // Function to fetch hobbies from API
  Future<List<Hobby>> fetchHobbies() async {
    const apiUrl = 'http://localhost:3000/api/hobbies';
    String? token = await _storageService.readSecureData("token");

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final hobbies = data
            .map((item) => Hobby(id: item['_id'], label: item['label']))
            .toList();

        print('Hobbies retrieved successfully');
        print(hobbies);

        return hobbies;
      } else {
        print(
            'Failed to retrieve hobbies. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while retrieving hobbies: $e');
    }

    return [];
  }

  // Function to make the POST request
  Future<void> submitForm() async {
    const url = "http://localhost:3000/api/v1/user";

    // Print the data to be sent to the server
    print('First Name: $_firstName');
    print('Last Name: $_lastName');
    print('Phone: $_phone');
    print('Email: $_email');
    print('Password: $_password');
    print('Hobbies: $_hobbies');

    try {
      // Make the POST request
      _formKey.currentState!.save();
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': _email,
          'nom': _lastName,
          'prenom': _firstName,
          'telephone': _phone,
          'password': _password,
          'hobbies': json.encode(_hobbies.map((hobbyId) {
            final hobby = hobbies.firstWhere((hobby) => hobby.id == hobbyId);
            return {
              'id': hobby.id,
              'label': hobby.label,
            };
          }).toList()),
        },
      );
      print(response.body);

      // Check the response status
      if (response.statusCode == 201) {
        // Request successful
        print('Form submitted successfully');
        _nextPage(context, LoginPage());
      } else {
        // Request failed
        print('Form submission failed');
      }

      _formKey.currentState!.reset();
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/images/logo.png'),
                const SizedBox(height: 16.0),
                const Text('Inscription'),
              ],
            ),
            const SizedBox(height: 10.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // [First Name]
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Prénom',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      print(_firstName);
                      _firstName = value!;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  // [Last Name]
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Nom',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _lastName = value!;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  // [Phone]
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Téléphone',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _phone = value!;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  // [Email]
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  // [Password]
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Mot de passe',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    obscureText: true,
                    onSaved: (value) {
                      _password = value!;
                      print(_password);
                    },
                  ),
                  const SizedBox(height: 12.0),
                  // Dropdown list for hobbies
                  FutureBuilder<List<Hobby>>(
                    future: fetchHobbies(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Hobby>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Erreur : ${snapshot.error}');
                      } else {
                        hobbies = snapshot.data!;
                        return Column(
                          children: hobbies.map((hobby) {
                            return CheckboxListTile(
                              title: Text(hobby.label),
                              value: _hobbies.contains(hobby.id),
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    _hobbies.add(hobby.id);
                                  } else {
                                    _hobbies.remove(hobby.id);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              style: style,
              onPressed: submitForm,
              child: const Text('S\'inscrire'),
            ),
            const SizedBox(height: 80.0),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:html';
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
  String _name = '';
  String _description = '';
  double _prix = 0;
  String email = '';
  String _date = '';
  String _lieu = '';
  List<String> _hobbies = [];
  String _latitude = '0';
String _longitude = '0';


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

  Future<Coordinates> getAddressCoordinates(String address) async {
    const apiKey = 'abc6b88b222268f459a9954ca72aad2d';
    print('Le lieu est $address');

    final encodedAddress = Uri.encodeQueryComponent(address);
    final url =
        'https://api.positionstack.com/v1/forward?access_key=$apiKey&query=$encodedAddress';

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['data'] != null && data['data'].isNotEmpty) {
        final result = data['data'][0];
        final latitude = result['latitude'] ;
        final longitude = result['longitude'] ;

        print('La latitude et longitude sont $latitude, $longitude');

        return Coordinates(latitude , longitude );
      } else {
        throw Exception('No coordinates found for the given address');
      }
    } catch (error) {
      print('Failed to fetch coordinates for the address: $error');
      throw error; // Rethrow the exception to be caught by the caller
    }
  }

  Future<void> createEvent() async {
    try {
      _formKey.currentState!.save();

      final token = await _storageService.readSecureData("token");
      final email = JwtDecoder.decode(token!)['username'];

      final eventUrl = 'http://localhost:3000/api/v1/user/event';
      final hobby = {
      'id': '645d4f38852b3cf66fac826f',
      'label': 'Jeux de société',
    };

      final event = {
        'email': email,
        'nom': _name,
        'description': _description,
        'date': _date,
        'lieu': {
          'lat': _latitude,
         'long': _longitude,
        },
        'prix': _prix,
        // 'eventId': 12345,
        'hobbies': [hobby],
      };

      final eventResponse = await http.post(
        Uri.parse(eventUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(event),
      );

      if (eventResponse.statusCode == 201) {
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
        print(
            'Échec de la création de l\'événement. Code de statut : ${eventResponse.statusCode}');
      }

      _formKey.currentState!.reset();
    } catch (e) {
      print('Error: $e');
    }
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
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom de l\'événement'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le nom de l\'événement';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir la description de l\'événement';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir la date de l\'événement';
                  }
                  return null;
                },
                onSaved: (value) {
                  _date = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prix'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le prix de l\'événement';
                  }
                  return null;
                },
                onSaved: (value) {
                  _prix = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Lieu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le lieu de l\'événement';
                  }
                  return null;
                },
                onSaved: (value) {
                  _lieu = value!;
                },
              ),
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
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    try {
                      final coordinates =
                          await getAddressCoordinates(_lieu);
                      _latitude = coordinates.latitude.toString();
                      _longitude = coordinates.longitude.toString();

                      createEvent();
                    } catch (error) {
                      print(
                          'Error occurred while fetching coordinates: $error');
                    }
                  }
                },
                child: Text('Créer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates(this.latitude, this.longitude);
}




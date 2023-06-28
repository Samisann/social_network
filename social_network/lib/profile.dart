import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:social_network/service/storage.dart';
import 'dart:convert';
import 'package:social_network/login.dart';
import 'home.dart'; 

class Profile extends StatefulWidget {
  // final StorageService storageService;

  // Profile({required this.storageService});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  String _login = '';
  String _password = '';
    final StorageService _storageService = StorageService();

  void _goToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => HomePage()),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _goToHome(context);
          },
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            // profile image
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 20),
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // user info
            FutureBuilder<UserInfo>(
              future: fetchUserInfo(),
              builder: (BuildContext context, AsyncSnapshot<UserInfo> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final userInfo = snapshot.data;
                  return Column(
                    children: [
                      Text('Email: ${userInfo!.email}'),
                      Text('Nom: ${userInfo.nom}'),
                      Text('Prénom: ${userInfo.prenom}'),
                      Text('Téléphone: ${userInfo.telephone}'),
                    ],
                  );
                }
              },
            ),
            // logout button
            Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  _logout(context);
                },
                child: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<UserInfo> fetchUserInfo() async {
  // try {
    // Récupérer le token depuis le service de stockage
    final token = await _storageService.readSecureData("token");
    print(JwtDecoder.decode(token!));

    // Extraire l'email à partir du token
    final email = JwtDecoder.decode(token!)['username'];

    // Effectuer la requête GET pour récupérer les informations de l'utilisateur
    final url = "http://localhost:3000/api/v1/user/$email";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return UserInfo.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch user info');
    }
  // } catch (e) {
  //   print('Error occurred while retrieving user info: $e');
  //   throw Exception('Failed to fetch user info');
  // }
}

}

class UserInfo {
  final String email;
  final String nom;
  final String prenom;
  final String telephone;

  UserInfo({
    required this.email,
    required this.nom,
    required this.prenom,
    required this.telephone,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      email: json['email'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
    );
  }
}

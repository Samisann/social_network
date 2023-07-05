import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_network/category.dart';
import 'package:social_network/models/Token.dart';
import 'package:social_network/profile.dart';
import 'package:social_network/create_event.dart';
import 'package:social_network/login.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:social_network/service/storage.dart';
import 'package:http/http.dart' as http;
import 'package:social_network/map.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? accountName;
  String? accountEmail;
  

  @override
  void initState() {
    super.initState();
    _loadUserDetailsFromToken();
  }

  void _loadUserDetailsFromToken() async {
    StorageService storageService = StorageService();
    String? token = await storageService.readSecureData('token');

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String? email = decodedToken['username'];

      try {
        UserInfo userInfo = await fetchUserInfo(token, email!);
        setState(() {
          accountName = '${userInfo.prenom} ${userInfo.nom}';
          accountEmail = userInfo.email;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<UserInfo> fetchUserInfo(String token, String email) async {
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
  }

  Future<List<dynamic>> fetchEventData() async {
        StorageService storageService = StorageService();

    const url = "http://localhost:3000/api/v1/user/allevent";
        String? token = await storageService.readSecureData('token');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['events'];
    } else {
      throw Exception('Failed to fetch event data');
    }
  }

  void _nextPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.blueGrey[100],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(accountName ?? ''),
              accountEmail: Text(accountEmail ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              leading: Icon(Icons.person),
              onTap: () {
                _nextPage(
                  context,
                  Profile(),
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: () {
                // TODO: Navigate to settings page
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: () {
                _nextPage(context, LoginPage());
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 400,
            child: Card(
              child: Image.network(
                'https://images.unsplash.com/photo-1682695795931-a546abdb6733?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwyMXx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsetsDirectional.only(end: 150, top: 10),
            height: 50,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Center(
              child: Text(
                'A la une',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return FutureBuilder<List<dynamic>>(
                      future: fetchEventData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<dynamic>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Erreur : ${snapshot.error}');
                        } else {
                          List<dynamic> events = snapshot.data!;
                          if (events.isEmpty) {
                            return Text('Aucun événement disponible');
                          } else {
                            final event = events[0]; 

                            final hobby = event['hobby'];
                            final price = event['price'];
                            final location = event['location'];

                            return Container(
                              margin: EdgeInsets.all(10),
                              width: 300,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      child: Image.network(
                                        'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y2luJUMzJUE5bWF8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
                                        height: 140,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          location,
                                          style: TextStyle(fontSize: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          '${price.toString()}€',
                                          style: TextStyle(fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          hobby,
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (int index) {
          switch (index) {
            case 0:
              _nextPage(context, HomePage());
              break;
            case 1:
              _nextPage(context, CategoryPage());
              break;
            case 2:
              _nextPage(context, MapPage());
              break;
            case 3:
              _nextPage(context, Profile());
              break;
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Carte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nextPage(context, CreateEvent());
        },
        child: Icon(Icons.add),
      ),
    );
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

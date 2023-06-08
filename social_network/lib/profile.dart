import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_network/models/User.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

void _nextPage(BuildContext context, Widget page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => page));
}

// Function to fetch hobbies from API
// Future<List<User>> getInfo() async {
//   const apiUrl =
//       'http://localhost:3000/api/v1/user/'; 
//       const param = 
//   try {
//     final response = await http.get(Uri.parse(apiUrl));

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);

//       final hobbies = data
//           .map((item) => User(: item['_id'], label: item['label']))
//           .toList();

//       print('Hobbies retrieved successfully');
//       print(hobbies);

//       return hobbies;
//     } else {
//       print('Failed to retrieve hobbies. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error occurred while retrieving hobbies: $e');
//   }

//   return []; // Return an empty list in case of error or no data available
// }

class _ProfileState extends State<Profile> {
  TextEditingController textController = TextEditingController();

  void test()
  {
    String text = textController.text;
    print(text);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Form(
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
                        'https://images.unsplash.com/photo-1685335220408-9ea26576e987?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=987&q=80'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // text fields
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                  ),
                ),
              ),
              // buttons

              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    _nextPage(context, LoginPage());
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
      ),
    );
  }
}

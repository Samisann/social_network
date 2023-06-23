import 'dart:async';
import 'package:flutter/material.dart';
import 'package:social_network/Home.dart';
import 'package:social_network/register.dart';
import 'package:social_network/models/Token.dart';
import 'package:http/http.dart' as http;
import 'package:social_network/service/storage.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

// next page method
void _nextPage(BuildContext context, Widget page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => page));
}

class _LoginPageState extends State<LoginPage> {
   final _formKey = GlobalKey<FormState>();
   String _login='';
   String _password='';
   final StorageService _storageService =  StorageService();

   Future<void> login() async {
    const url = "http://localhost:3000/api/v1/auth/login";

    // Print the data to be sent to the server
    print('Login: $_login');
    print('Password: $_password');

    try {
      // Make the POST request
      _formKey.currentState!.save();
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': _login,
          'password': _password
        },
      );
      print(response.body);

      // Check the response status
      if (response.statusCode == 200) {
        // Request successful
        print('Form submitted successfully');
      } else {
        // Request failed
        print('Form submission failed');
      }
      Token token =  Token.fromJson(jsonDecode(response.body));
      _storageService.writeSecureData("token",token.accessToken).then((value) => _formKey.currentState!.reset());
      // Reset the form
    } catch (e) {
      // Error occurred
      print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        //full width button
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                // flutter logo
                Image.asset('assets/images/logo.png'),

                const SizedBox(height: 16.0),
                const Text('Connexion'),
              ],
            ),
            const SizedBox(height: 120.0),
            // TODO: Remove filled: true values (103)
            // TODO: Add TextField widgets (101)
            // [Name]
            Form(
              key: _formKey,
              child: Column(
                children: [
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                labelText: 'Login',
              ),
              validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your login';
                      }
                      return null;
                    },
             onSaved: (value) {
              print(value);
                      _login = value!;
              }
            ),
            // spacer
            const SizedBox(height: 12.0),
            // [Password]
            // forgot password
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                labelText: 'Mot de passe',
              ),
              obscureText: true,
              validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                onSaved: (value) {
                _password = value!;
                }
            ),
                ]
              )
            ),
            // TODO: Add button bar (101)
            const SizedBox(height: 20.0),

            ElevatedButton(
                style: style,
               onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        login();
                      }
               },
                child: Text('Se connecter')),
            //full width button

            const SizedBox(height: 200.0),
            TextButton(
  onPressed: (() => {_nextPage(context, Register())}),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Pas de compte?',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
      SizedBox(width: 5),
      Text(
        'S\'inscrire',
        style: TextStyle(
          decoration: TextDecoration.underline, // Ajoute un soulignement au texte
        ),
      ),
    ],
  ),
)
,
          ],
        ),
      ),
    );
  }
}

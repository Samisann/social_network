import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:social_network/Home.dart';
import 'package:social_network/register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

void _nextPage(BuildContext context, Widget page) {
  // if user is logged in, go to home page

  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (BuildContext context) => page));
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> _loginUser(
      TextEditingController email, TextEditingController pass) async {
    const apiUrl = "http://localhost:3000/api/v1/user/login";
    final emailText = email.text;
    final passwordText = pass.text;
    final parameter = "?email=$emailText&password=$passwordText";
    final response = await http.get(Uri.parse(apiUrl + parameter));
    print("valeur controller: $emailText, $passwordText");
    print(response.body);
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      print(userData);
      final storedPassword = userData['password'];

      if (storedPassword == passwordText) {
        // Mot de passe valide, accéder à la page d'accueil
        _nextPage(context, HomePage());
        print("Mot de passe valide");
        return true;
      } else {
        // Mot de passe invalide
        print("Mot de passe invalide");
        return false;
      }
    }
    print(response.statusCode);
    return false;
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
            // [Name]
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Email',
              ),
            ),
            // spacer
            const SizedBox(height: 12.0),
            // [Password]
            // forgot password
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Mot de passe',
              ),
              obscureText: true,
            ),

            // TODO: Add button bar (101)
            const SizedBox(height: 20.0),

            ElevatedButton(
                style: style,
                onPressed: (() => {
                      // _nextPage(context, HomePage()),
                      _loginUser(emailController, passwordController)
                    }),
                child: Text('Se connecter')),
            //full width button

            const SizedBox(height: 200.0),
            TextButton(
              onPressed: (() => {_nextPage(context, Register())}),
              child: const Row(
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
                      decoration: TextDecoration
                          .underline, // Ajoute un soulignement au texte
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

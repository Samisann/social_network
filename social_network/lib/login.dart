import 'dart:async';
import 'package:flutter/material.dart';
import 'package:social_network/Home.dart';
import 'package:social_network/register.dart';

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
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                labelText: 'Nom',
              ),
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
            ),

            // TODO: Add button bar (101)
            const SizedBox(height: 20.0),

            ElevatedButton(
                style: style,
                onPressed: (() => {
                      _nextPage(context, HomePage()),
                    }),
                child: Text('Se connecter')),
            //full width button

            const SizedBox(height: 200.0),
            ElevatedButton(
                style: style,
                onPressed: (() => {_nextPage(context, Register())}),
                child: Text('S\'inscrire')),
          ],
        ),
      ),
    );
  }
}

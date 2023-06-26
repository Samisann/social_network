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

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _login = '';
  String _password = '';
  final StorageService _storageService = StorageService();

  void _nextPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => page));
  }

  Future<void> login() async {
    const url = "http://localhost:3000/api/v1/auth/login";

    // Affiche les données envoyées au serveur
    print('Login : $_login');
    print('Mot de passe : $_password');

    try {
      // Effectue la requête POST
      _formKey.currentState!.save();
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': _login,
          'password': _password
        },
      );
      print(response.body);

      // Vérifie le statut de la réponse
      if (response.statusCode == 200) {
        // Requête réussie
        print('Formulaire soumis avec succès');
      } else {
        // Échec de la requête
        print('Échec de la soumission du formulaire');
      }
      Token token = Token.fromJson(jsonDecode(response.body));
      _storageService.writeSecureData("token", token.accessToken).then(
          (value) => _formKey.currentState!.reset());
      // Réinitialise le formulaire
    } catch (e) {
      // Une erreur s'est produite
      print('Erreur : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        // bouton largeur complète
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                // logo Flutter
                Image.asset('assets/images/logo.png'),

                const SizedBox(height: 16.0),
                const Text('Connexion'),
              ],
            ),
            const SizedBox(height: 120.0),
            // TODO: Supprimer les valeurs `filled: true` (103)
            // TODO: Ajouter les widgets TextField (101)
            // [Nom]
            Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez saisir votre identifiant';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      print(value);
                      _login = value!;
                    }),
                // espace
                const SizedBox(height: 12.0),
                // [Mot de passe]
                // mot de passe oublié
                TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Mot de passe',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez saisir votre mot de passe';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      print(value);
                      _password = value!;
                    }),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('Mot de passe oublié ?'),
                      onPressed: () {
                        // TODO: Implémenter la fonctionnalité Mot de passe oublié
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  style: style,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      login();
                      _nextPage(context, HomePage(storageService: null,));
                    }
                  },
                  child: const Text('Se connecter'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Vous n'avez pas de compte ?"),
                    TextButton(
                      child: const Text('S\'inscrire'),
                      onPressed: () {
                        _nextPage(context, Register());

                      },
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

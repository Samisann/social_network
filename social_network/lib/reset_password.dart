import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  Future<void> resetPassword(BuildContext context) async {
    final String apiUrl = 'http://localhost:3000/api/v1/user/reset-password';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'email': emailController.text,
        },
      );

      if (response.statusCode == 200) {
        // Le mot de passe a été réinitialisé avec succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Le mot de passe a été réinitialisé avec succès.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // La réinitialisation du mot de passe a échoué
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('La réinitialisation du mot de passe a échoué.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Une erreur s'est produite lors de la réinitialisation du mot de passe
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Une erreur s\'est produite lors de la réinitialisation du mot de passe.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réinitialiser le mot de passe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Champ email
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20.0),
            // Bouton réinitialiser
            ElevatedButton(
              onPressed: () {
                resetPassword(context);
              },
              child: Text('Réinitialiser'),
            ),
          ],
        ),
      ),
    );
  }
}

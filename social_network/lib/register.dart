import 'package:flutter/material.dart';
import 'package:social_network/login.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  List<String> _hobbies = [];

  // Navigate to the next page
  void _nextPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => page));
  }

// // function to make a get request 
// Future<void> getData() async {
//   const url = "http://localhost:3000/api/v1/user";
//   try {
//     final response = await http.get(Uri.parse(url));
//     print(response.body);
//   } catch (e) {
//     print('Error: $e');
//   }
// }
// Function to make the POST request
  Future<void> submitForm() async {
    const url = "http://localhost:3000/api/v1/user";

    // print of the data to be sent to the server
    print('First Name: $_firstName');
    print('Last Name: $_lastName');
    print('Phone: $_phone');
    print('Email: $_email');
    print('Password: $_password');

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

      // Reset the form
      _formKey.currentState!.reset();
    } catch (e) {
      // Error occurred
      print('Error: $e');
    }
  }

  // Submit the form
  void _submitForm() {
    // TODO: Implement form submission

    print('First Name: $_firstName');
    print('Last Name: $_lastName');
    print('Phone: $_phone');
    print('Email: $_email');
    print('Password: $_password');
    print('Confirm Password: $_confirmPassword');
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
                    },
                  ),
                  const SizedBox(height: 12.0),
                  // dropdown list for the hobbies
                  
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {
                      submitForm();
                    },
                    child: const Text('S\'inscrire'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Déjà un compte?'),
                TextButton(
                  onPressed: () {
                    _nextPage(context, LoginPage());
                  },
                  child: const Text('Se connecter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

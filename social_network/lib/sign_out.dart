import 'package:flutter/material.dart';




class SignOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Out'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Sign Out'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
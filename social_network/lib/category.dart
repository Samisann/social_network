import 'dart:io';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(10, (index) {
          return Center(
            child: Container(
              margin: EdgeInsets.all(10),
              width: 400,
              height: 300,
              child: Card(
                // all 4 corners rounded

                child: Column(
                  // shape

                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y2luJUMzJUE5bWF8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',

                      fit: BoxFit.cover,
                      //shape rounded
                    ),
                    Text('Bordeaux'),
                    Text('Cinéma'),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

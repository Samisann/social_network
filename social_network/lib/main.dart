import 'package:flutter/material.dart';
import './login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash screen',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.orange,

        // Define the default font family.
        fontFamily: 'Poppins',

        // Define the default TextTheme. Use this to specify the default
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image_splash.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xFF111122)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset('assets/images/logo.png')),
                  Spacer(flex: 14),
                  Text(
                    'Anything you want, just right here for all.',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(flex: 1),
                  Text(
                    'Find YOUR best place',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Spacer(flex: 2),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orangeAccent,
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Center(child: Text("Commencer maintenant")),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

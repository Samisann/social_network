import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('John Doe'),
              accountEmail: Text('johndoe@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150x150.png?text=John+Doe'),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              leading: Icon(Icons.person),
              onTap: () {
                // TODO: Navigate to profile page
              },
            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
              onTap: () {
                // TODO: Navigate to settings page
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
              onTap: () {
                // TODO: Implement logout functionality
              },
            ),
          ],
        ),
      ),
      body: // card slider widget
          Column(
        children: [
          // hero image
          Container(
            height: 400,
            child: Card(
              child: Image.network(
                'https://images.unsplash.com/photo-1682695795931-a546abdb6733?ixlib=rb-4.0.3&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwyMXx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          //rounded corners container
          Container(
            // negative margin on the left
            margin: EdgeInsetsDirectional.only(end: 150, top: 20),
            height: 50,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                'A la une',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          // card slider

          Expanded(
            // alignement at the bottom
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 200,
                      height: 100,
                      child: Card(
                        child: Column(
                          children: [
                            Image.network(
                              'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y2luJUMzJUE5bWF8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
                              height: 100,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                            Text('Bordeaux'),
                            Text('Cinéma'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

// Suggested code may be subject to a license. Learn more: ~LicenseLog:3479317541.
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('S.W.0.L.E. Profile',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            color: Colors.amber[800],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation:  0.0,
      ),

      body: Padding(
          padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/brucewayne.jpg'),
                  radius: 50,
                ),
              ),
              Divider(
                height: 90,
                color: Colors.grey[800],
              ),
              Text('NAME',
                style: TextStyle(
                    color: Colors.grey[600],
                    letterSpacing: 2,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10),
              Text('Bruce Wayne',
                style: TextStyle(
                    color: Colors.amber[500],
                    letterSpacing: 2,
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 30),
              Text('Age',
                style: TextStyle(
                    color: Colors.grey[600],
                    letterSpacing: 2,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10),
              Text('60',
                style: TextStyle(
                    color: Colors.amber[500],
                    letterSpacing: 2,
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Icon(
                    Icons.email,
                    color: Colors.grey[400],
                  ),
                  SizedBox(width: 10),
                  Text(
                    'bruce.wayne@gmail.com',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      letterSpacing: 1.0,
                    ),
                  )
                ],
              )
            ],
          )
      ),
    );
  }
}
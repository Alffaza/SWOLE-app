import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:swole_app/pages/edit_birthdate.dart';

// Suggested code may be subject to a license. Learn more: ~LicenseLog:3479317541.
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'S.W.0.L.E. Profile',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            color: Colors.amber[800],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0.0,
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
                height: 70,
                color: Colors.grey[800],
              ),
              // Text(
              //   'NAME',
              //   style: TextStyle(
              //       color: Colors.grey[600],
              //       letterSpacing: 2,
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold),
              // ),

              // SizedBox(height: 10),
              // Text(
              //   user.displayName ?? "No name",
              //   style: TextStyle(
              //       color: Colors.amber[500],
              //       letterSpacing: 2,
              //       fontSize: 28,
              //       fontWeight: FontWeight.bold),
              // )

              Text(
                'Age',
                style: TextStyle(
                    color: Colors.grey[600],
                    letterSpacing: 2,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    '60',
                    style: TextStyle(
                        color: Colors.amber[500],
                        letterSpacing: 2,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(child: SizedBox(),),

                  IconButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditBirthdatePage()));
                  }, icon: Icon(Icons.edit))
                ],
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
                    user.email ?? "No email",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      letterSpacing: 1.0,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.grey[600],
                        letterSpacing: 2,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
                ],
              )
            ],
          )),
    );
  }
}

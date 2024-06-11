import 'package:flutter/material.dart';
import 'package:swole_app/components/my_button.dart';
import 'package:swole_app/components/my_textfield.dart';
import 'package:swole_app/components/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center (
              child: CircularProgressIndicator()
          );
        }
    );

    void wrongCredentials() {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Incorrect Email or Password'),
            );
          });
    }

    try {
      print(usernameController.text);
      print(passwordController.text);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text
      );

      Navigator.pop(context);
      print("Login sukses");
    } on FirebaseAuthException catch (e) {
      print({"eek": e});
      Navigator.pop(context);
      wrongCredentials();
    }

    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body:
      SingleChildScrollView(

        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 150),

                // welcome back, you've been missed!
                Text(
                  'Enter username and password!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                // username textfield
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),


                const SizedBox(height: 10),

                MyButton(
                  onTap: signUserIn,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

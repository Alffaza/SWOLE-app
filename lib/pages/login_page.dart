import 'package:flutter/material.dart';
import 'package:swole_app/components/my_button.dart';
import 'package:swole_app/components/my_textfield.dart';
import 'package:swole_app/components/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swole_app/pages/auth_page.dart';
import 'package:swole_app/pages/register_page.dart';

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
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthPage()));
      print("Login sukses");
    } on FirebaseAuthException catch (e) {
      print({"eek": e});
      Navigator.pop(context);
      wrongCredentials();
    }

    // Navigator.pop(context);
  }

  void signInWithGoogle() async {
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
              title: Text('Login failed'),
            );
          });
    }

    try {
      print(usernameController.text);
      print(passwordController.text);

      await FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());

      Navigator.pop(context);
      print("Login sukses");
    } on FirebaseAuthException catch (e) {
      print({"kee": e});
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
                  'Enter email and password!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                // username textfield
                MyTextField(
                  controller: usernameController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 15),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 15),

                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                  },
                  child: const Text('Don\'t have an account? Register here!'),
                ),

                const SizedBox(height: 15),

                MyButton(
                  onTap: signUserIn,
                ),

                const SizedBox(height: 15),

                GestureDetector(
                  onTap: signInWithGoogle,
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      // color: Colors.amber,
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign In with Google",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

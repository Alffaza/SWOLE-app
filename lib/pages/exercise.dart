import 'package:flutter/material.dart';
import 'new_exercise.dart';

// Suggested code may be subject to a license. Learn more: ~LicenseLog:3479317541.
class ExercisePage extends StatelessWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      children: [
        Text(
          "Start",
          style: TextStyle(fontSize: 25, color: Colors.black54),
        ),
        SizedBox(height: 10,),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewExercisePage()));
          },
          child: Text("Start Exercise", style: TextStyle(color: Colors.black),),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return Colors.amber;
            },),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
          ),
        ),
        SizedBox(height: 15,),
        Text(
          "Routines",
          style: TextStyle(fontSize: 25, color: Colors.black54),
        ),
        SizedBox(height: 10,),
        Text("TODO"),
      ],
    );
  }
}

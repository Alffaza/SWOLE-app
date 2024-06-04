import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swole_app/firebase_options.dart';

class CreateRoutinePage extends StatefulWidget {
  const CreateRoutinePage({Key? key}) : super(key: key);

  @override
  State<CreateRoutinePage> createState() => _CreateRoutinePageState();
}

class _CreateRoutinePageState extends State<CreateRoutinePage> {

  //text controller for routine name
  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Routine',
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
     padding: const EdgeInsets.all(16.0),
     child: Column(
      children: <Widget>[
      TextField(
        controller: textController,
        decoration: InputDecoration(
        labelText: 'Routine Name',
        border: OutlineInputBorder(),
          ),
       ),
      ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text("save"),
      ),
    );
  }
}

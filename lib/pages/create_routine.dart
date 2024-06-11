import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swole_app/firebase_options.dart';
import 'package:swole_app/services/routine_service.dart';

class CreateRoutinePage extends StatefulWidget {
  const CreateRoutinePage({Key? key}) : super(key: key);

  @override
  State<CreateRoutinePage> createState() => _CreateRoutinePageState();
}

class _CreateRoutinePageState extends State<CreateRoutinePage> {
  // Text controller for routine name
  final TextEditingController nameController = TextEditingController();
  // List to keep track of selected exercises
  List<String> selectedExercises = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create New Routine',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Routine Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: RoutineService(FirebaseAuth.instance.currentUser!.uid).getExercisesStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> exercises = snapshot.data!.docs;

                  // Display as a list with checkboxes
                  return ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      // Get each individual doc
                      QueryDocumentSnapshot document = exercises[index];
                      String docID = document.id;
                      // Get data from each doc
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      String exerciseName = data['name'];

                      // Display as a checkbox list tile
                      return CheckboxListTile(
                        title: Text(exerciseName),
                        value: selectedExercises.contains(docID),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedExercises.add(docID);
                            } else {
                              selectedExercises.remove(docID);
                            }
                          });
                        },
                      );
                    },
                  );
                } else {
                  return const Text("No exercises..");
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (nameController.text.isNotEmpty) {
            Map<String, dynamic> newRoutine = {
              'name': nameController.text,
              'exercises': selectedExercises.map((id) => FirebaseFirestore.instance.doc('exercises/$id')).toList(),
            };
            nameController.clear();
            selectedExercises.clear();

            RoutineService(FirebaseAuth.instance.currentUser!.uid).addRoutineRecord(newRoutine);

            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('SUCCESS'),
                content: const Text('Successfully recorded your routine!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

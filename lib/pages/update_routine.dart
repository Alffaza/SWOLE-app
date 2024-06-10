import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swole_app/services/routine_service.dart';

class UpdateRoutinePage extends StatefulWidget {
  final String routineId;
  final String routineName;

  const UpdateRoutinePage({
    Key? key,
    required this.routineId,
    required this.routineName,
  }) : super(key: key);

  @override
  State<UpdateRoutinePage> createState() => _UpdateRoutinePageState();
}

class _UpdateRoutinePageState extends State<UpdateRoutinePage> {
  final TextEditingController nameController = TextEditingController();
  List<String> selectedExercises = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoutineData();
  }

  void _loadRoutineData() async {
    DocumentSnapshot routineDoc = await RoutineService().routines.doc(widget.routineId).get();
    Map<String, dynamic> data = routineDoc.data() as Map<String, dynamic>;

    setState(() {
      nameController.text = data['name'];
      selectedExercises = List<String>.from(data['exercises'].map((e) => (e as DocumentReference).id));
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: RoutineService().routines.doc(widget.routineId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              String routineName = data['name'];
              return Text(
                routineName,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Colors.amber[800],
                ),
              );
            } else {
              return Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Colors.amber[800],
                ),
              );
            }
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0.0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
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
              stream: RoutineService().getExercisesStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> exercises = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot document = exercises[index];
                      String docID = document.id;
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      String exerciseName = data['name'];

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
            Map<String, dynamic> updatedRoutine = {
              'name': nameController.text,
              'exercises': selectedExercises.map((id) => FirebaseFirestore.instance.doc('exercises/$id')).toList(),
            };

            RoutineService().updateRoutineRecord(widget.routineId, updatedRoutine);

            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('SUCCESS'),
                content: const Text('Successfully updated your routine!'),
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

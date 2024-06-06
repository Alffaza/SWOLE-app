import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swole_app/services/routine_service.dart';

class ReadRoutinePage extends StatefulWidget {
  final String routineId;
  final String routineName;

  const ReadRoutinePage({ //prerequisite checker
    Key? key,
    required this.routineId,
    required this.routineName,
  }) : super(key: key);

  @override
  State<ReadRoutinePage> createState() => _ReadRoutinePageState();
}

class _ReadRoutinePageState extends State<ReadRoutinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.routineName, //based on id
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
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('routines').doc(widget.routineId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); //load
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); //error checker
          } else if (snapshot.hasData && snapshot.data!.exists) {
            List<dynamic> exercisesRefs = snapshot.data!['exercises']; //list
            return ListView.builder(
              itemCount: exercisesRefs.length,
              itemBuilder: (context, index) {
                DocumentReference exerciseRef = exercisesRefs[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: exerciseRef.get(),
                  builder: (context, exerciseSnapshot) {
                    if (exerciseSnapshot.connectionState == ConnectionState.waiting) { //load and error checker
                      return ListTile(title: Text("Loading..."));
                    } else if (exerciseSnapshot.hasError) {
                      return ListTile(title: Text("Error: ${exerciseSnapshot.error}"));
                    } else if (exerciseSnapshot.hasData && exerciseSnapshot.data!.exists) {
                      String exerciseName = exerciseSnapshot.data!['name'];
                      return ListTile(title: Text(exerciseName));
                    } else {
                      return ListTile(title: Text("Exercise not found"));
                    }
                  },
                );
              },
            );
          } else {
            return Center(child: Text("Routine not found"));
          }
        },
      ),
    );
  }
}

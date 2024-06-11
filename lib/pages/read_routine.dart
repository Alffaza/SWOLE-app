import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReadRoutinePage extends StatefulWidget {
  final String userId;
  final String routineId;
  final String routineName;

  const ReadRoutinePage({
    Key? key,
    required this.userId,
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
          widget.routineName,
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
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection('routines')
            .doc(widget.routineId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.exists) {
            List<dynamic> exercisesRefs = snapshot.data!['exercises'];
            return ListView.builder(
              itemCount: exercisesRefs.length,
              itemBuilder: (context, index) {
                DocumentReference exerciseRef = exercisesRefs[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: exerciseRef.get(),
                  builder: (context, exerciseSnapshot) {
                    if (exerciseSnapshot.connectionState == ConnectionState.waiting) {
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

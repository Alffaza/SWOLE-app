import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/routine_service.dart';
import 'new_exercise.dart';
import 'package:swole_app/services/sessions_service.dart';

// Suggested code may be subject to a license. Learn more: ~LicenseLog:3479317541.
class ExercisePage extends StatelessWidget {
  const ExercisePage({Key? key}) : super(key: key);

  List<Widget> createExercises(List<dynamic> exercises) {
    var widgets = exercises.map((e) {
      return FutureBuilder(
          future: e.get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data!.data() as Map<String, dynamic>;

              print({"ngik": data});

              var name = data["name"];
              var type = data["type"];
              // var volume = e[type].toString();

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              );
            }

            return Text("...");
          });
    }).toList();

    return widgets as List<Widget>;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      children: [
        Text(
          "Start",
          style: TextStyle(fontSize: 25, color: Colors.black54),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewExercisePage()));
          },
          child: Text(
            "Start Exercise",
            style: TextStyle(color: Colors.black),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
              (states) {
                return Colors.amber;
              },
            ),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          "Routines",
          style: TextStyle(fontSize: 25, color: Colors.black54),
        ),
        SizedBox(
          height: 10,
        ),
        StreamBuilder<QuerySnapshot>(
            stream: RoutineService(FirebaseAuth.instance.currentUser!.uid).getRoutinesStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot> routines = snapshot.data!.docs;

                return Column(
                  children: [
                    for (var routine in routines)
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              routine["name"],
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500),
                            ),
                            // Text(routine["description"]),
                            Column(
                              children: createExercises(routine["exercises"]),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () async {
                            List<Map<String, dynamic>> exercisesData = [];

                            for (var exercise in routine["exercises"]) {
                              DocumentSnapshot snapshot = await exercise.get();
                              if (snapshot.exists) {
                                exercisesData.add({
                                  "name": snapshot["name"],
                                  "type": snapshot["type"],
                                  "id": snapshot.id,
                                  "volume": 0,
                                });
                              }
                            }

                            print({"ngek": exercisesData});

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewExercisePage(
                                          exercises: exercisesData,
                                        )));
                          },
                        ),
                      ),
                  ],
                );

                return Text("asd");
              }
              return Text("No routines available.");
            })
      ],
    );
  }
}

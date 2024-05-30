import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swole_app/services/sessions_service.dart';

// create stateless widget for home page
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3479317541.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SessionsService sessionsService = SessionsService();

  List<Widget> createExercises(List<dynamic> exercises) {

    var widgets = exercises.map((e) {

      return FutureBuilder(
          future: e["exercise"].get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data!.data() as Map<String, dynamic>;

              var name = data["name"];
              var type = data["type"];
              var volume = e[type].toString();

              return Row(
                children: [
                  Text(name),
                  Text('${volume} ${type == "reps" ? "reps" : "minutes"}')
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
    return StreamBuilder<QuerySnapshot>(
        stream: sessionsService.getSessionsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List sessionsList = snapshot.data!.docs;

            return ListView.builder(
                itemCount: sessionsList.length,
                itemBuilder: (context, index) {
                  var document = sessionsList[0];
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                  return Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.amber,
                    child: Column(
                      children: [
                        Text(data["note"]),
                        Column(
                          children: [
                            Text("Time"),
                            Text(data["time"].toString())
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Text("Workout",),
                        Column(
                          children: createExercises(data["exercises"]),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return const Text("No session...");
          }
        });
  }
}

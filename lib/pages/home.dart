import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swole_app/services/sessions_service.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';

// create stateless widget for home page
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3479317541.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Widget> createExercises(List<dynamic> exercises) {
    final user = FirebaseAuth.instance.currentUser!;
    final SessionsService sessionsService = SessionsService(user.uid);

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    '${volume} ${type == "reps" ? "reps" : "minutes"}',
                    style: TextStyle(fontSize: 15),
                  )
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
    initializeDateFormatting();

    final user = FirebaseAuth.instance.currentUser!;
    final SessionsService sessionsService = SessionsService(user.uid);

    return StreamBuilder<QuerySnapshot>(
        stream: sessionsService.getSessionsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List sessionsList = snapshot.data!.docs;

            if (sessionsList.isEmpty) {
              return const Center(
                child: Text("No session..."),
              );
            }

            return ListView.builder(
                itemCount: sessionsList.length,
                itemBuilder: (context, index) {
                  var document = sessionsList[index];
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                  final dateFormatter = DateFormat("dd MMMM HH:mm");
                  final workoutDate =
                      dateFormatter.format(data["date"].toDate());

                  return Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              data["note"] == "" ? "No note" : data["note"],
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500),
                            ),
                            Expanded(child: SizedBox()),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                sessionsService.deleteSession(document.id);
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text('${workoutDate} (${data["time"]} minutes)'),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Workout ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 5,
                        ),
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

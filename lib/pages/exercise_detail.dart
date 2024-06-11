import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swole_app/services/sessions_service.dart';

// Suggested code may be subject to a license. Learn more: ~LicenseLog:3479317541.
class ExerciseDetailPage extends StatefulWidget {
  const ExerciseDetailPage({Key? key}) : super(key: key);

  @override
  State<ExerciseDetailPage> createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {

  List<Widget> createExercises(BuildContext context, List exercises) {
    var widgets = exercises.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.pop(context, {
            "name": data["name"],
            "type": data["type"],
            "id": doc.id,
          });
        },
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data["name"],
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
                Text(data["part"],
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
                SizedBox(
                  height: 20,
                ),
              ],
            )
          ],
        ),
      );
    }).toList();

    return widgets as List<Widget>;
  }

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser!;
    final SessionsService sessionsService = SessionsService(user.uid);

    return StreamBuilder<QuerySnapshot>(
        stream: sessionsService.getExercisesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List exercisesList = snapshot.data!.docs;

            return Scaffold(
              body: ListView(
                padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Exercises',
                        style: TextStyle(fontSize: 25, color: Colors.black54),
                      ),
                    ],
                  ),
                  Divider(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: createExercises(context, exercisesList),
                  ),
                ],
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: Text("Loading..."),
            ),
          );
        });
  }
}

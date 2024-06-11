import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swole_app/container.dart';
import 'dart:async';

import 'package:swole_app/pages/exercise_detail.dart';
import 'package:swole_app/services/sessions_service.dart';

// Suggested code may be subject to a license. Learn more: ~LicenseLog:3479317541.
class NewExercisePage extends StatefulWidget {
  List<dynamic> exercises;

  NewExercisePage({ //prerequisite checker
    Key? key,
    this.exercises = const [],
  }) : super(key: key);

  @override
  State<NewExercisePage> createState() => _NewExercisePageState();
}

class _NewExercisePageState extends State<NewExercisePage> {
  SessionsService sessionsService = SessionsService();

  final _stopwatch = Stopwatch();
  int _elapsedTime = 0;
  late String _elapsedTimeString;
  late Timer timer;

  var noteController = TextEditingController();
  List<dynamic> exercises = [];
  Map<String, TextEditingController> textControllers = {};

  @override
  void initState() {
    super.initState();

    print("ngok");
    print(widget.exercises);

    exercises = List<dynamic>.from(widget.exercises);

    for (var exercise in exercises) {
      var textController = TextEditingController(text: "0");
      textControllers[exercise["id"]] = textController;
    }

    timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        // Update elapsed time only if the stopwatch is running
        if (_stopwatch.isRunning) {
          setState(() {
            _elapsedTime = (_stopwatch.elapsedMilliseconds / 1000).round();
            if (_elapsedTime < 60) {
              _elapsedTimeString = _elapsedTime.toString() + "s";
            } else {
              _elapsedTimeString = (_elapsedTime / 60).floor().toString() +
                  "m " +
                  (_elapsedTime % 60).toString() +
                  "s";
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _stopwatch.start();

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exercise',
                style: TextStyle(fontSize: 25, color: Colors.black54),
              ),
              ElevatedButton(
                onPressed: () async {
                  var addedExercises = exercises.map((exercise) {
                    return {
                      "exercise": FirebaseFirestore.instance
                          .collection('exercises')
                          .doc(exercise["id"]),
                      exercise["type"] == "reps" ? "reps" : "time":
                          textControllers[exercise["id"]]!.text,
                    };
                  }).toList();

                  await sessionsService.addSession({
                    "date": Timestamp.now(),
                    "time": (_elapsedTime / 60).ceil(),
                    "note": noteController.text,
                    "exercises": addedExercises
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PageContainer(),
                    ),
                  );
                },
                child: Text(
                  "Finish",
                  style: TextStyle(color: Colors.black),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      return Color.fromRGBO(255, 255, 255, 1);
                    },
                  ),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.amber))),
                ),
              ),
            ],
          ),
          Divider(
            height: 40,
          ),
          SizedBox(
            width: 250,
            child: TextField(
                decoration: InputDecoration(
                  hintText: "Note",
                ),
                controller: noteController),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Duration",
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            _elapsedTimeString,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: exercises.map((exercise) {
              return Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exercise["name"],
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w400)),
                      Text(
                          exercise["type"] == "time"
                              ? "Time (minutes)"
                              : "Reps",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300)),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  Expanded(child: SizedBox()),
                  SizedBox(
                    width: 25,
                    child: TextField(
                        decoration: null,
                        controller: textControllers[exercise["id"]],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () async {
              var exercise = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExerciseDetailPage()));

              var exerciseExist = exercises.firstWhere(
                  (element) => element["id"] == exercise["id"],
                  orElse: () => null);

              if (exerciseExist != null) {
                return;
              }

              exercise["volume"] = 0;

              print({
                "ja": exercise
              });
              
              print(widget.exercises);
              exercises.add(exercise);

              var textController = TextEditingController(text: "0");
              textControllers[exercise["id"]] = textController;
            },
            child: Text(
              "+ Add Exercise",
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
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: Text(
              "Discard",
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                  return Colors.red;
                },
              ),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ),
    );
  }
}

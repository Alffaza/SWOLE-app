import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:swole_app/services/exercise_recommendation.dart';
import 'package:swole_app/services/health_record.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

// Suggested code may be subject to a license. Learn more: ~LicenseLog:3479317541.
class HealthRecordPage extends StatefulWidget {
  const HealthRecordPage({Key? key}) : super(key: key);

  @override
  State<HealthRecordPage> createState() => _HealthRecordPageState();
}

class _HealthRecordPageState extends State<HealthRecordPage> {
  final TextEditingController controllerTensionDIA = TextEditingController();
  final TextEditingController controllerTensionSYS = TextEditingController();
  final TextEditingController controllerBloodSugar = TextEditingController();
  final TextEditingController controllerBodyWeight = TextEditingController();
  dynamic decimalInputFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
    TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text;
      return text.isEmpty
          ? newValue
          : double.tryParse(text) == null
          ? oldValue
          : newValue;
    }),
  ];

  List<ExerciseTips> exerciseTipsList = [];

  var healthRecordKeys = ['blood_sugar', 'tension_DIA', 'tension_SYS', 'body_weight'];
  Map<String,String> keyLabelsMap = {
    'blood_sugar' : 'Blood Sugar',
    'tension_DIA' : 'Tension DIA',
    'tension_SYS' : 'Tension SYS',
    'body_weight' : 'Body Weight'
  };
  String dropdownValue = 'blood_sugar';

  @override
  Widget build(BuildContext context) {

    var healthRecordService = HealthRecordService(FirebaseAuth.instance.currentUser!.uid);
    var exerciseRecommenderService = ExerciseRecommenderService();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Health Record'),
      ),
      body: 
      SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 320,
                height: 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue[100],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 7,
                      spreadRadius: 2,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child:
                Column(
                  children: [
                    DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: healthRecordKeys.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(keyLabelsMap[value]!),
                      );
                    }).toList()),
                    StreamBuilder<QuerySnapshot>(
                      stream: healthRecordService.getUserHealthRecord(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        List recordList = snapshot.data!.docs;

                        Map<String, List<ChartData>> healthRecords = {
                          'blood_sugar': [],
                          'tension_DIA': [],
                          'tension_SYS': [],
                          'body_weight': []
                        };

                        for (var recordData in recordList) {
                          for (var k in healthRecordKeys) {
                              if (recordData.data().containsKey(k)) {
                                healthRecords[k]?.add(ChartData(
                                    recordData['time'].toDate(), recordData[k]));
                                // print("$k : ${recordData[k]} ${recordData["time"].toDate()}");
                              }

                            }
                        }
                        // print(healthRecords['blood_sugar']);
                        // for (var i in healthRecords['blood_sugar']!) {
                        //   print("blood sugar ${i.x} ${i.y}");
                        // }

                        return SfCartesianChart(
                            legend: const Legend(isVisible: true),
                            primaryXAxis: const DateTimeAxis(
                                majorGridLines: MajorGridLines(width: 0),
                                edgeLabelPlacement: EdgeLabelPlacement.shift,
                                intervalType: DateTimeIntervalType.days),
                            series: <LineSeries<ChartData, DateTime>>[
                              // Renders line chart
                              LineSeries<ChartData, DateTime>(
                                  name: keyLabelsMap[dropdownValue],
                                  dataSource: healthRecords[dropdownValue],
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y
                              ),
                            ]
                        );
                      }
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffDEFDFD),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 7,
                      spreadRadius: 2,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                        'Record your health',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),

                    ),
                    Text(Timestamp.now().toDate().toString()),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 0.0),
                      child: TextFormField(
                        keyboardType:  const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        controller: controllerBloodSugar,
                        decoration: const InputDecoration(
                            labelText: 'Blood Sugar',
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder()
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 0.0),
                      child: TextFormField(
                        keyboardType:  const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        controller: controllerTensionDIA,
                        decoration: const InputDecoration(
                            labelText: 'Tension DIA',
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder()
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 0.0),
                      child: TextFormField(
                        keyboardType:  const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        controller: controllerTensionSYS,
                        decoration: const InputDecoration(
                            labelText: 'Tension SYS',
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder()
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 0.0),
                      child: TextFormField(
                        keyboardType:  const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        controller: controllerBodyWeight,
                        decoration: const InputDecoration(
                            labelText: 'Body Weight',
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder()
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 300.0)),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: () async {
                              Map<String, dynamic> newRecord = {};

                              if(controllerBloodSugar.text != '') {
                                newRecord['blood_sugar'] = double.parse(controllerBloodSugar.text);
                                controllerBloodSugar.clear();
                              }

                              if(controllerTensionDIA.text != '') {
                                newRecord['tension_DIA'] = double.parse(controllerTensionDIA.text);
                                controllerTensionDIA.clear();
                              }

                              if(controllerTensionSYS.text != '') {
                                newRecord['tension_SYS'] = double.parse(controllerTensionSYS.text);
                                controllerTensionSYS.clear();
                              }

                              if(controllerBodyWeight.text != '') {
                                newRecord['body_weight'] = double.parse(controllerBodyWeight.text);
                                controllerBodyWeight.clear();
                              }

                              healthRecordService.addHealthRecord(newRecord);
                              StreamGroup<QuerySnapshot> exerciseRecommenderStreamGroup = StreamGroup();
                              List<Stream<QuerySnapshot>> streamList = [];
                              for(var k in newRecord.keys){
                                if (k == 'time') continue;
                                var v = newRecord[k];
                                // exerciseRecommenderStreamGroup.add(exerciseRecommenderService.getExerciseStreamGT(k, v));
                                // exerciseRecommenderStreamGroup.add(exerciseRecommenderService.getExerciseStreamLT(k, v));
                                streamList.add(exerciseRecommenderService.getExerciseStreamGT(k, v));
                                streamList.add(exerciseRecommenderService.getExerciseStreamLT(k, v));
                              }

                              // Stream<QuerySnapshot> exerciseRecommenderStream = StreamGroup.merge(streamList);

                              Stream<QuerySnapshot> exerciseRecommenderStream = exerciseRecommenderService.getExerciseStream();

                              // var er = await exerciseRecommenderService.checkHealthRecord(newRecord);
                              // print("status: ${er['status']}");

                              setState(() {});
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                  StreamBuilder(
                                      stream: exerciseRecommenderStream,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return
                                            const AlertDialog(
                                              content: CircularProgressIndicator(),
                                            );
                                        }
                                        List<QueryDocumentSnapshot> recommendations = snapshot.data!.docs;
                                        List<ExerciseTips> exerciseTips = [];
                                        print(recommendations.length);
                                        for(var recommendation in recommendations){
                                          bool recommendedForUser = false;
                                          List<dynamic> exercisesRef = recommendation['exercises'];
                                          String evaluatedField = recommendation['health_record'];
                                          String recommendationTitle = "Your $evaluatedField is not good";

                                          if(!newRecord.containsKey(evaluatedField)) continue;

                                          if (recommendation['comparator'] == '>') {
                                            if (newRecord[evaluatedField] > recommendation['value']) recommendedForUser = true;
                                            recommendationTitle = "Your $evaluatedField is too high, you should try the following exercises:";
                                          }
                                          if (recommendation['comparator'] == '<') {
                                            if (newRecord[evaluatedField] < recommendation['value']) recommendedForUser = true;
                                            recommendationTitle = "Your $evaluatedField is too low, you should try the following exercises:";
                                          }
                                          if (recommendedForUser) {
                                            ExerciseTips et = ExerciseTips(recommendationTitle);
                                            for (var e in exercisesRef) {
                                              et.addContent(e);
                                            }
                                            exerciseTips.add(et);
                                          }
                                        }

                                        if (exerciseTips.isEmpty)
                                        {
                                          return AlertDialog(
                                            title: const Text('Health record updated!'),
                                            content: const Text('Your health seems fine!'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, 'OK');
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        }

                                        return AlertDialog(
                                            title: const Text('Health record updated!'),
                                            content:
                                            SizedBox(
                                              width: double.maxFinite,
                                              height: double.maxFinite,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: exerciseTips.length,
                                                itemBuilder: (context, tipIndex) {
                                                  var exerciseTip = exerciseTips[tipIndex];
                                                  return ListTile(
                                                    title: Text(exerciseTip.tipTitle),
                                                    subtitle:
                                                    Expanded(
                                                      flex: 1,
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: exerciseTip
                                                              .content.length,
                                                          itemBuilder: (context,
                                                              exIndex) {
                                                            return FutureBuilder<
                                                                DocumentSnapshot>(
                                                              future: exerciseTip
                                                                  .content[exIndex]
                                                                  .get(),
                                                              builder: (context,
                                                                  exerciseSnapshot) {
                                                                if (exerciseSnapshot
                                                                    .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return ListTile(title: Text("Loading..."));
                                                                } else
                                                                if (exerciseSnapshot
                                                                    .hasError) {
                                                                  return ListTile(
                                                                      title: Text(
                                                                          "Error: ${exerciseSnapshot
                                                                              .error}"));
                                                                } else
                                                                if (exerciseSnapshot
                                                                    .hasData &&
                                                                    exerciseSnapshot
                                                                        .data!
                                                                        .exists) {
                                                                  String exerciseName = exerciseSnapshot
                                                                      .data!['name'];
                                                                  return ListTile(
                                                                      title: Text(
                                                                          exerciseName));
                                                                } else {
                                                                  return ListTile(
                                                                      title: Text("Exercise not found")
                                                                  );
                                                                }
                                                              },
                                                            );
                                                          }
                                                      ),
                                                    ),
                                                  );
                                                }
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, 'OK');
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        }
                                  )
                              );
                            },
                            child: const Text('Add'),
                          )
                        )
                      ],
                    )
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final num y;
}
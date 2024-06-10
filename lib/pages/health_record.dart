import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
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
  final HealthRecordService healthRecordService = HealthRecordService();

  final TextEditingController controllerTensionDIA = TextEditingController();
  final TextEditingController controllerTensionSYS = TextEditingController();
  final TextEditingController controllerBloodSugar = TextEditingController();
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

  List<ChartData> chartData = <ChartData>[
    ChartData(DateTime(2015, 1, 1, 1), 1.13),
    ChartData(DateTime(2015, 1, 2, 2), 1.12),
    ChartData(DateTime(2015, 1, 3, 3), 1.08),
    ChartData(DateTime(2015, 1, 4, 4), 1.12),
    ChartData(DateTime(2015, 1, 5, 5), 1.1),
    ChartData(DateTime(2015, 1, 6, 6), 1.12),
    ChartData(DateTime(2015, 1, 7, 7), 1.1),
    ChartData(DateTime(2015, 1, 8, 8), 1.12),
    ChartData(DateTime(2015, 1, 9, 9), 1.16),
    ChartData(DateTime(2015, 1, 10, 10), 1.1),
  ];

  void updateHealthRecordGraph() {
    chartData = [];

    healthRecordService.getUserHealthRecord();
  }

  @override
  Widget build(BuildContext context) {

    // HealthRecordService().testAddHealthRecord();
    // print('===Health Record===');
    // print(HealthRecordService().getUserHealthRecord());

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
                height: 220,
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
                StreamBuilder<QuerySnapshot>(
                  stream: healthRecordService.getUserHealthRecord(),
                  builder: (context, snapshot) {
                    List recordList = snapshot.data!.docs;

                    var healthRecordKeys = ['blood_sugar', 'tension_DIA', 'tension_SYS'];

                    Map<String, List<ChartData>> healthRecords = {
                      'blood_sugar': [],
                      'tension_DIA': [],
                      'tension_SYS': []
                    };

                    for (var recordData in recordList) {
                      for (var k in healthRecordKeys) {
                          if (recordData.data().containsKey(k)) {
                            healthRecords[k]?.add(ChartData(
                                recordData['time'].toDate(), recordData[k]));
                          }
                        }
                    }

                    // print(recordList[0].data() as Map);

                    return SfCartesianChart(
                        primaryXAxis: const DateTimeAxis(
                            majorGridLines: MajorGridLines(width: 0),
                            edgeLabelPlacement: EdgeLabelPlacement.shift,
                            intervalType: DateTimeIntervalType.days),
                        series: <LineSeries<ChartData, DateTime>>[
                          // Renders line chart
                          LineSeries<ChartData, DateTime>(
                              dataSource: healthRecords['blood_sugar'],
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y
                          )
                        ]
                    );
                  }
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 320,
                height: 360,
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
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType:  const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        controller: controllerBloodSugar,
                        decoration: const InputDecoration(
                            labelText: 'Blood Sugar',
                            border: OutlineInputBorder()
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType:  const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        controller: controllerTensionDIA,
                        decoration: const InputDecoration(
                            labelText: 'Tension DIA',
                            border: OutlineInputBorder()
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType:  const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        controller: controllerTensionSYS,
                        decoration: const InputDecoration(
                            labelText: 'Tension SYS',
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
                            onPressed: () {
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

                              healthRecordService.addHealthRecord(newRecord);
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                  AlertDialog(
                                    title: const Text('SUCCESS'),
                                    content: const Text('Successfully recorded your health!'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
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
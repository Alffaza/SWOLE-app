import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swole_app/services/health_record.dart';

// Suggested code may be subject to a license. Learn more: ~LicenseLog:3479317541.
class HealthRecordPage extends StatelessWidget {
  const HealthRecordPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextEditingController controllerTensionDIA = TextEditingController();
    final TextEditingController controllerTensionSYS = TextEditingController();
    final TextEditingController controllerBloodSugar = TextEditingController();

    // HealthRecordService().testAddHealthRecord();
    print('===Health Record===');
    print(HealthRecordService().getUserHealthRecord());

    return Scaffold(
      appBar: AppBar(
        title: Text('Health Record'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: 320,
              height: 160,
              child: Center(child: Text('Graph Placeholder')),
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
            ),
            SizedBox(height: 20),
            // Container(
            //   width: 320,
            //   height: 200,
            //   child: Column(
            //     children: [
            //       Text('Record your health'),
            //       Text(Timestamp.now().toDate().toString()),
            //       TextField(
            //         controller: controllerBloodSugar,
            //       ),
            //       TextField(
            //         controller: controllerTensionDIA,
            //       ),
            //       TextField(
            //         controller: controllerTensionSYS,
            //       ),
            //     ]
            //   ),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     color: Colors.blue[100],
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey.withOpacity(0.5),
            //         blurRadius: 7,
            //         spreadRadius: 2,
            //         offset: const Offset(0, 3), // changes position of shadow
            //       ),
            //     ],
            //   ),
            // ),
            
            SizedBox(
              child: StreamBuilder<QuerySnapshot>(
                  stream: HealthRecordService().getUserHealthRecord(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List recordList = snapshot.data!.docs;
                      for (var n in recordList){
                        print(n['blood_sugar']);
                      }
                      print(recordList.length);
                      return
                        SizedBox(
                          height: 200.0,
                          child: ListView.builder(
                              itemCount: recordList.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot document = recordList[index];
                                String docId = document.id;

                                Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;

                                String noteText = data['blood_sugar'].toString();

                                return
                                  ListTile(
                                    title: Text(noteText),
                                    trailing:
                                    IconButton(
                                      iconSize: 20,
                                      onPressed: () {

                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  );
                              }),
                        );
                    } else {
                      return const Text("Notes not found");
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
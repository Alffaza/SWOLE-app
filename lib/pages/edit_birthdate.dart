import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:swole_app/services/health_record.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

// Suggested code may be subject to a license. Learn more: ~LicenseLog:3479317541.
class EditBirthdatePage extends StatefulWidget {
  const EditBirthdatePage({Key? key}) : super(key: key);

  @override
  State<EditBirthdatePage> createState() => _EditBirthdatePageState();
}

class _EditBirthdatePageState extends State<EditBirthdatePage> {
  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edit Birthdate'),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),

            child: InputDatePickerFormField(
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              onDateSubmitted: (DateTime value) async {
                try {
                  print({
                    "birthdate": value,
                    "user": FirebaseAuth.instance.currentUser!.uid,
                  });

                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({"birthdate": Timestamp.fromDate(value)});

                  print("done update");

                  Navigator.pop(context);
                } catch (e) {
                  print({
                    "nguak": e,
                  });
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

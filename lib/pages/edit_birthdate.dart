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
          Expanded(
            child: SizedBox(
              height: 150,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selectedDate,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    selectedDate = newDateTime;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              try {
                print({
                  "birthdate": selectedDate,
                  "user": FirebaseAuth.instance.currentUser!.uid,
                });

                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({
                  "name": "Ryo"
                });

                print("done update");

                Navigator.pop(context);
              } catch (e) {
                print({
                  "nguak": e,
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

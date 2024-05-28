import 'package:cloud_firestore/cloud_firestore.dart';

final userId = '5fWy2Ep1WbK59J6Ncn1a';

class HealthRecordService {
  final CollectionReference userHealthRecords =
    FirebaseFirestore.instance.collection('users').doc(userId).collection('health_records');

  Future<void> addHealthRecord(Map<String, dynamic> record) {
    record['time'] = Timestamp.now();
    return userHealthRecords.add(record);
  }

  Stream<QuerySnapshot> getUserHealthRecord() {
    final notesStream = userHealthRecords.orderBy('time').snapshots();

    return notesStream;
  }

  // Future<void> updateNote(String docId, String newNote) {
  //   return notes.doc(docId).update({
  //     'note': newNote,
  //     'timestamp': Timestamp.now()
  //   });
  // }

  Future<void> deleteHealthRecord(String docId) {
    return userHealthRecords.doc(docId).delete();
  }

  Future<void> testAddHealthRecord() {
    Map<String, dynamic> new_record= {
      'blood_sugar': 123,
      'tension_DIA': 10,
      'tension_SYS': 10
    };
    return addHealthRecord(new_record);
  }
}

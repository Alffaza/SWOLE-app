import 'package:cloud_firestore/cloud_firestore.dart';

class RoutineService {
  final CollectionReference routineRecords =
  FirebaseFirestore.instance.collection('routines');

  Future<void> addRoutineRecord(Map<String, dynamic> record) {
    return routineRecords.add(record);
  }

  Stream<QuerySnapshot> getRoutineRecords() {
    return routineRecords.snapshots();
  }

  Future<void> updateRoutineRecord(String docId, Map<String, dynamic> updatedData) {
    return routineRecords.doc(docId).update(updatedData);
  }

  Future<void> deleteRoutineRecord(String docId) {
    return routineRecords.doc(docId).delete();
  }


}

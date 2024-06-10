import 'package:cloud_firestore/cloud_firestore.dart';

class RoutineService {
  final CollectionReference routines =
  FirebaseFirestore.instance.collection('routines');

  final CollectionReference exercises =
  FirebaseFirestore.instance.collection('exercises');

  Future<void> addRoutineRecord(Map<String, dynamic> record) {
    return routines.add(record);
  }

  Stream<QuerySnapshot> getRoutinesStream() {
    final routinesStream = routines.snapshots();

    return routinesStream;
  }


  Future<void> updateRoutineRecord(String docId, Map<String, dynamic> updatedData) {
    return routines.doc(docId).update(updatedData);
  }

  Future<void> deleteRoutineRecord(String docId) {
    return routines.doc(docId).delete();
  }

  Stream<QuerySnapshot> getExercisesStream() {
    final exercisesStream = exercises.snapshots();

    return exercisesStream;
  }


}

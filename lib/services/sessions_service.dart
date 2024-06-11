import 'package:cloud_firestore/cloud_firestore.dart';

class SessionsService {
  final CollectionReference sessions =
  FirebaseFirestore.instance.collection("users").doc("x5lX47E5HsS1QBLQJidRyPetRJb2").collection('sessions');

  final CollectionReference exercises =
  FirebaseFirestore.instance.collection('exercises');

  Future<void> addSession(session) {
    return sessions.add(session);
  }

  Stream<QuerySnapshot> getSessionsStream()  {
    final routinesStream = sessions.snapshots();

    return routinesStream;
  }

  void deleteSession(sessionId) {
    sessions.doc(sessionId).delete();
  }

  Stream<QuerySnapshot> getExercisesStream() {
    final exercisesStream = exercises.snapshots();

    return exercisesStream;
  }
}

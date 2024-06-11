import 'package:cloud_firestore/cloud_firestore.dart';

class SessionsService {
  final String _userId;
  final CollectionReference sessions;

  SessionsService(this._userId)
      : sessions = FirebaseFirestore.instance
            .collection("users")
            .doc(_userId)
            .collection('sessions');

  final CollectionReference exercises =
      FirebaseFirestore.instance.collection('exercises');

  Future<void> addSession(session) {
    return sessions.add(session);
  }

  Stream<QuerySnapshot> getSessionsStream() {
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

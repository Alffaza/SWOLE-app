import 'package:cloud_firestore/cloud_firestore.dart';

class SessionsService {
  final CollectionReference notes =
  FirebaseFirestore.instance.collection('sessions');

  Future<void> addNote(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  Stream<QuerySnapshot> getSessionsStream()  {
    final routinesStream = notes.snapshots();

    return routinesStream;
  }

  Future<void> updateNote(String docId, String newNote) {
    return notes.doc(docId).update({
      'note': newNote,
      'timestamp': Timestamp.now()
    });
  }

  Future<void> deleteNote(String docId) {
    return notes.doc(docId).delete();
  }
}

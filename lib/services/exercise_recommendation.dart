import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseRecommenderService {
  final CollectionReference exerciseRecommendations;

  ExerciseRecommenderService()
      : exerciseRecommendations = FirebaseFirestore.instance
      .collection("exercise_recommendations");

  Stream<QuerySnapshot> getExerciseStreamGT(String k, num v) {
    return
      exerciseRecommendations
        .where('health_record', isEqualTo: k)
        .where('comparator', isEqualTo: '>')
        .where('value', isLessThan: v).snapshots();
  }

  Stream<QuerySnapshot> getExerciseStreamLT(String k, num v) {
    return
      exerciseRecommendations
          .where('health_record', isEqualTo: k)
          .where('comparator', isEqualTo: '<')
          .where('value', isGreaterThan: v).snapshots();
  }

  Stream<QuerySnapshot> getExerciseStream() {
    return
      exerciseRecommendations.snapshots();
  }
}

class ExerciseTips {
  String tipTitle;
  List<DocumentReference> content = [];
  ExerciseTips(this.tipTitle);
  void addContent(DocumentReference newContent){
    content.add(newContent);
  }
}

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

  // Future<Map<String,dynamic>> checkHealthRecord(Map<String, dynamic> record) async {
  //   Map<String,dynamic> result = {
  //     'status': 'ok'
  //   };
  //   List<ExerciseTips> exerciseTipsList = [];
  //
  //   for(var k in record.keys) {
  //     if (k == 'time') continue;
  //     num v = record[k];
  //     var evaluatedFields = userExerciseRecommendations.where('health_record', arrayContainsAny: [k]);
  //
  //     // Evaluate records that are less than minimum required
  //     var clt = evaluatedFields
  //         .where('value', isGreaterThan: v);
  //
  //     var cltSnapshot = await clt.get();
  //     if (cltSnapshot.docs.isNotEmpty){
  //       ExerciseTips exerciseTips = ExerciseTips('your $k is too low, try these exercises!');
  //       for (var doc in cltSnapshot.docs) {
  //         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //         if (data['comparator'] != '<') continue;
  //         List<CollectionReference> exercises = data['exercise'];
  //         for (CollectionReference exercise in exercises) {
  //           var exerciseSnapshot = await exercise.get();
  //           if (exerciseSnapshot.docs.isNotEmpty) {
  //             for (var exerciseDoc in exerciseSnapshot.docs) {
  //               Map<String, dynamic> eData = exerciseDoc.data() as Map<String, dynamic>;
  //               exerciseTips.addContent(eData['name']);
  //             }
  //           }
  //         }
  //       }
  //       exerciseTipsList.add(exerciseTips);
  //     }
  //
  //     // Evaluate records that are greater than minimum required
  //     var cgt = evaluatedFields;
  //         // .where('value', isLessThan: v);
  //
  //     var cgtSnapshot = await cgt.get();
  //     if (cgtSnapshot.docs.isNotEmpty){
  //       ExerciseTips exerciseTips = ExerciseTips('your $k is too high, try these exercises!');
  //       for (var doc in cgtSnapshot.docs) {
  //         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //         if (data['comparator'] != '>') continue;
  //         List<CollectionReference> exercises = data['exercise'];
  //         for (CollectionReference exercise in exercises) {
  //           var exerciseSnapshot = await exercise.get();
  //           if (exerciseSnapshot.docs.isNotEmpty) {
  //             for (var exerciseDoc in exerciseSnapshot.docs) {
  //               Map<String, dynamic> eData = exerciseDoc.data() as Map<String, dynamic>;
  //               exerciseTips.addContent(eData['name']);
  //             }
  //           }
  //         }
  //       }
  //       exerciseTipsList.add(exerciseTips);
  //     }
  //   }
  //   result['tips'] = exerciseTipsList;
  //   if(exerciseTipsList.isNotEmpty) result['status'] = 'not ok';
  //   return result;
  // }
}

class ExerciseTips {
  String tipTitle;
  List<DocumentReference> content = [];
  ExerciseTips(this.tipTitle);
  void addContent(DocumentReference newContent){
    content.add(newContent);
  }
}

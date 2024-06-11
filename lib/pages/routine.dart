import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swole_app/pages/create_routine.dart';
import 'package:swole_app/pages/update_routine.dart';
import 'package:swole_app/pages/read_routine.dart'; // Import the ReadRoutinePage
import 'package:swole_app/services/routine_service.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({Key? key}) : super(key: key);

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Routine',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            color: Colors.amber[800],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0.0,
      ),
      body: StreamBuilder<QuerySnapshot>(
<<<<<<< Updated upstream
        stream: RoutineService().getRoutinesStream(),
=======
        stream: RoutineService(userId).getRoutinesStream(),
>>>>>>> Stashed changes
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> routines = snapshot.data!.docs;

            // Display as a list
            return ListView.builder(
              itemCount: routines.length,
              itemBuilder: (context, index) {
                // Get each individual doc
                QueryDocumentSnapshot document = routines[index];
                String docID = document.id;
                // Get data from each doc
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String routineName = data['name'];

                // Display as a list tile
                return ListTile(
                  title: Text(routineName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateRoutinePage(
                                routineId: docID,
                                routineName: routineName,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, docID, routineName);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadRoutinePage(
                          userId: userId,
                          routineId: docID,
                          routineName: routineName,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Text("No routines..");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateRoutinePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String docID, String routineName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Routine'),
          content: Text('Are you sure you want to delete the routine "$routineName"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                RoutineService().deleteRoutineRecord(docID);
                Navigator.pop(context, 'Delete');
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

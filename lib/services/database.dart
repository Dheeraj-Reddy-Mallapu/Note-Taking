import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final time = DateTime.now().toLocal().toString().substring(0, 19);
final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;
List<Map<String, dynamic>> notes = [];

class FireStore {
  Future createNote({
    required String title,
    required String content,
    required String id,
    required bool deleted,
    //required int color,
  }) async {
    final docNote = db.collection(user.uid).doc(id);

    final json = {
      'id': id,
      'title': title,
      'content': content,
      'deleted': deleted,
      'createdAt': time,
      'modifiedAt': time,
      'deletedAt': time,
      //'color': color,
    };

    await docNote.set(json);
  }

  Future createBinNote({
    required String id,
    required bool deleted,
  }) async {
    final docNote = db.collection(user.uid).doc(id);

    final json = {
      'deleted': deleted,
      'deletedAt': time,
    };

    await docNote.update(json);
  }

  Future restoreNote({
    required String id,
    required bool deleted,
  }) async {
    final docNote = db.collection(user.uid).doc(id);

    final json = {
      'deleted': deleted,
      'restoredAt': time,
    };

    await docNote.update(json);
  }

  Stream<List> readNotes({required String orderBy, required bool descending}) => db
      .collection(user.uid)
      .orderBy(orderBy, descending: descending)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Future updateNote({
    required String title,
    required String content,
    required String id,
  }) async {
    final docNote = db.collection(user.uid).doc(id);

    docNote.update({
      'title': title,
      'content': content,
      'modifiedAt': time,
    });
  }

  Future deleteNote({required String id}) async {
    final docNote = db.collection(user.uid).doc(id);

    docNote.delete();
  }
}

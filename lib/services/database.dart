import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;
List<Map<String, dynamic>> notes = [];

class FireStore {
  final time = DateTime.now().toLocal().toString().substring(0, 19);
  Future createNote({
    required String uid,
    required String title,
    required String content,
    required String id,
    required bool deleted,
    required int color,
    required String sentBy,
    //required int positionId,
  }) async {
    final docNote = db.collection(uid).doc(id);

    final json = {
      'id': id,
      'title': title,
      'content': content,
      'sentBy': sentBy,
      'deleted': deleted,
      'createdAt': time,
      'modifiedAt': time,
      'deletedAt': time,
      'color': color,
      //'positionId': positionId,
    };

    await docNote.set(json);
  }

  Future addFriend({
    required String frndName,
    required String frndUid,
  }) async {
    final docNote = db.collection(user.uid).doc('friends').collection('list').doc(frndUid);

    final json = {
      'frndName': frndName,
      'frndUid': frndUid,
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

  Stream<List> getFrndsList() => db
      .collection(user.uid)
      .doc('friends')
      .collection('list')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Future updateNote({
    required String title,
    required String content,
    required String id,
    required int color,
  }) async {
    final docNote = db.collection(user.uid).doc(id);

    docNote.update({
      'title': title,
      'content': content,
      'color': color,
      'modifiedAt': time,
    });
  }

  Future updateFrndName({
    required String frndName,
    required String frndUid,
  }) async {
    final docNote = db.collection(user.uid).doc('friends').collection('list').doc(frndUid);

    docNote.update({
      'frndName': frndName,
    });
  }

  Future deleteNote({required String id}) async {
    final docNote = db.collection(user.uid).doc(id);

    docNote.delete();
  }

  Future removeFrnd({required String frndUid}) async {
    final docNote = db.collection(user.uid).doc('friends').collection('list').doc(frndUid);

    docNote.delete();
  }
}

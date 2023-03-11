import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final time = DateTime.now().toLocal().toString().substring(0, 19);
final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;

class FireStore {
  Future createNote({
    required String title,
    required String content,
    required String id,
  }) async {
    final docNote = db.collection(user.uid).doc(id);

    final json = {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': time,
      'modifiedAt': time,
    };

    await docNote.set(json);
  }

  Future createBinNote({
    required String title,
    required String content,
    required String id,
    required String createdAt,
    required String modifiedAt,
  }) async {
    final docNote = db.collection(user.uid).doc('recycleBin').collection('notes').doc(id);

    final json = {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
      'deletedAt': time,
    };

    await docNote.set(json);
  }

  Future restoreNote({
    required String title,
    required String content,
    required String id,
    required String createdAt,
    required String modifiedAt,
  }) async {
    final docNote = db.collection(user.uid).doc(id);

    final json = {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'modifiedAt': modifiedAt,
    };

    await docNote.set(json);
  }

  Stream<List> readNotes({required String orderBy, required bool descending}) =>
      db.collection(user.uid).orderBy(orderBy, descending: descending).snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Stream<List> readBinNotes() => db
      .collection(user.uid)
      .doc('recycleBin')
      .collection('notes')
      .orderBy('deletedAt', descending: true)
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

  Future deleteBinNote({required String id}) async {
    final docNote = db.collection(user.uid).doc('recycleBin').collection('notes').doc(id);

    docNote.delete();
  }
}

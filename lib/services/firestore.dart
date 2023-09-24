import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_taking_firebase/objects/drawing.dart';

final db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;

List<Map<String, dynamic>> allDocs = [];

class FireStore {
  Future createNote({
    required String uid,
    required String title,
    required String content,
    required String id,
    required bool deleted,
    required int color,
    required String sentBy,
  }) async {
    final doc = db.collection(uid).doc(id);
    final time = DateTime.now().toLocal().toString().substring(0, 19);

    final json = {
      'id': id,
      'type': 'note',
      'title': title,
      'content': content,
      'sentBy': sentBy,
      'deleted': deleted,
      'createdAt': time,
      'modifiedAt': time,
      'deletedAt': '',
      'color': color,
    };

    await doc.set(json);
  }

  Future saveDrawingDetails(
      {required bool isEditMode,
      required String uid,
      required String id,
      required String title,
      required String url,
      required int canvaColor}) async {
    final doc = db.collection(uid).doc(id);

    final time = DateTime.now().toLocal().toString().substring(0, 19);

    Map<String, dynamic> json = Drawing(
      id: id,
      type: 'drawing',
      title: title,
      url: url,
      sentBy: '',
      sentTo: [],
      deleted: false,
      isFav: false,
      createdAt: time,
      modifiedAt: time,
      deletedAt: '',
      restoredAt: '',
      color: 0,
      canvaColor: canvaColor,
    ).toMap();

    if (isEditMode) {
      json = {
        'title': title,
        'url': url,
        'modifiedAt': time,
      };

      await doc.update(json);
    } else {
      await doc.set(json);
    }
  }

  Future addFriend({
    required String frndName,
    required String frndUid,
  }) async {
    final doc = db.collection(user.uid).doc('friends').collection('list').doc(frndUid);

    final json = {
      'frndName': frndName,
      'frndUid': frndUid,
    };

    await doc.set(json);
  }

  Future createBinNote({
    required String id,
    required bool deleted,
  }) async {
    final doc = db.collection(user.uid).doc(id);
    final time = DateTime.now().toLocal().toString().substring(0, 19);
    final json = {
      'deleted': deleted,
      'deletedAt': time,
    };

    await doc.update(json);
  }

  Future restoreNote({
    required String id,
    required bool deleted,
  }) async {
    final doc = db.collection(user.uid).doc(id);
    final time = DateTime.now().toLocal().toString().substring(0, 19);
    final json = {
      'deleted': deleted,
      'restoredAt': time,
    };

    await doc.update(json);
  }

  Stream<List> getDocs({required String orderBy, required bool descending}) => db
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

  // Stream<List> readDrawings() => db
  //     .collection(user.uid)
  //     .doc('drawings')
  //     .collection('list')
  //     .snapshots()
  //     .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Future updateNote({
    required String title,
    required String content,
    required String id,
    required int color,
  }) async {
    final doc = db.collection(user.uid).doc(id);
    final time = DateTime.now().toLocal().toString().substring(0, 19);
    doc.update({
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
    final doc = db.collection(user.uid).doc('friends').collection('list').doc(frndUid);

    doc.update({
      'frndName': frndName,
    });
  }

  Future deleteNote({required String id}) async {
    final doc = db.collection(user.uid).doc(id);

    doc.delete();
  }

  Future removeFrnd({required String frndUid}) async {
    final doc = db.collection(user.uid).doc('friends').collection('list').doc(frndUid);

    doc.delete();
  }
}

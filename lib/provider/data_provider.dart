import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_taking_firebase/services/firestore.dart';

class DataProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _allNotes = [];
  List<Map<String, dynamic>> get allNotes => _allNotes;
  StreamSubscription<QuerySnapshot>? _notesCollectionSubscription;

  void startNotesStrean(String familySpaceId) {
    _notesCollectionSubscription = db.collection(user.uid).snapshots().listen(
      (event) {
        _allNotes = event.docs.map((e) => (e.data())).toList();

        notifyListeners();
      },
      onError: (e) => Get.snackbar('Oops!', e.toString()),
    );
  }

  void stopNotesStream() => _notesCollectionSubscription?.cancel();
}

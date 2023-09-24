import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:note_taking_firebase/services/firestore.dart';

final storageInstance = FirebaseStorage.instance;

Future<String> saveDrawingToStorage(List<Map<String, dynamic>> drawing, String id) async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Reference storageRef = storage.ref().child('${user.uid}/$id.json');

  final jsonString = jsonEncode(drawing);

  // Convert the JSON string to Uint8List.
  final data = Uint8List.fromList(utf8.encode(jsonString));

  // Upload the Uint8List as a file to Firebase Storage.
  final uploadTask = await storageRef.putData(data, SettableMetadata(contentType: 'application/json'));

  String downloadUrl = await uploadTask.ref.getDownloadURL();

  return downloadUrl;
}

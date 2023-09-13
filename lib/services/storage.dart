import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:note_taking_firebase/screens/drawings/new_drawing.dart';
import 'package:note_taking_firebase/services/firestore.dart';

final storageInstance = FirebaseStorage.instance;

Future<String> saveDrawingPointsToStorage(List<DrawingPoint> drawingPoints, String id) async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Reference storageRef = storage.ref().child('${user.uid}/$id.json');

  // Serialize the drawing points to JSON.
  final jsonData = drawingPoints.map((point) {
    double x = point.offset.dx;
    double y = point.offset.dx;

    if (x == double.infinity) {
      x = 1234567890;
    }
    if (y == double.infinity) {
      y = 1234567890;
    }
    return {
      'offsetX': x,
      'offsetY': y,
      'paintColor': point.paint.color.value,
      'strokeWidth': point.paint.strokeWidth,
      // Add other properties as needed.
    };
  }).toList();

  final jsonString = jsonEncode(jsonData);

  // Convert the JSON string to Uint8List.
  final data = Uint8List.fromList(utf8.encode(jsonString));

  // Upload the Uint8List as a file to Firebase Storage.
  final uploadTask = await storageRef.putData(data);

  String downloadUrl = await uploadTask.ref.getDownloadURL();

  return downloadUrl;
}

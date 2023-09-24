// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:note_taking_firebase/screens/drawings/drawing_pad.dart';
// // import 'package:note_taking_firebase/screens/drawings/view_drawing.dart';
// import 'package:note_taking_firebase/services/firestore.dart';
// import 'package:note_taking_firebase/widgets/floating_btn.dart';

// class Drawings extends StatefulWidget {
//   const Drawings({super.key});

//   @override
//   State<Drawings> createState() => _DrawingsState();
// }

// class _DrawingsState extends State<Drawings> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: StreamBuilder<List>(
//         stream: FireStore().readDrawings(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text(snapshot.error.toString());
//           } else if (snapshot.hasData) {
//             final drawingsData = snapshot.data!;
//             List<Map<String, dynamic>> allDrawings = drawingsData as List<Map<String, dynamic>>;
//             // List<Map<String, dynamic>> filteredDrawings = [];
//             return ListView.builder(
//               itemCount: allDrawings.length,
//               itemBuilder: (context, index) {
//                 final drawing = allDrawings.elementAt(index);
//                 String title = utf8.decode(base64Url.decode(drawing['title']));

//                 return ListTile(
//                   title: Text(title == '' ? 'Drawing #${index + 1}' : title),
//                   onTap: () => Get.to(() => DrawingPad(isEditMode: true, drawing: drawing)),
//                 );
//               },
//             );
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: const FloatingBtn(currentScreenIndex: 1),
//     );
//   }
// }

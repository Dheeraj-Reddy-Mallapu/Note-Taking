import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_taking_firebase/screens/drawings/new_drawing.dart';
import 'package:note_taking_firebase/screens/drawings/view_drawing.dart';
import 'package:note_taking_firebase/services/firestore.dart';

class Drawings extends StatefulWidget {
  const Drawings({super.key});

  @override
  State<Drawings> createState() => _DrawingsState();
}

class _DrawingsState extends State<Drawings> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<List>(
          stream: FireStore().readDrawings(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              final drawingsData = snapshot.data!;
              List<Map<String, dynamic>> allDrawings = drawingsData as List<Map<String, dynamic>>;
              // List<Map<String, dynamic>> filteredDrawings = [];
              return ListView.builder(
                itemCount: allDrawings.length,
                itemBuilder: (context, index) {
                  final drawing = allDrawings.elementAt(index);
                  String title = drawing['title'];

                  return ListTile(
                    title: Text(title == '' ? 'Drawing #${index + 1}' : title),
                    onTap: () => Get.to(() => ViewDrawing(drawing: drawing)),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: OpenContainer(
          openBuilder: (context, _) => const NewDrawing(),
          closedShape: const CircleBorder(),
          closedBuilder: (context, VoidCallback openContainer) => Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color.secondaryContainer),
            child: Icon(Icons.add, color: color.primary),
          ),
        ),
      ),
    );
  }
}

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_firebase/screens/drawings/drawing_pad.dart';
import 'package:note_taking_firebase/screens/notes/new_note.dart';

class FloatingBtn extends StatelessWidget {
  const FloatingBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OpenContainer(
            openBuilder: (context, _) => const NewNote(),
            closedShape: const CircleBorder(),
            closedBuilder: (context, VoidCallback openContainer) => const CircleAvatar(
              radius: 25,
              child: Icon(Icons.note_add_outlined),
            ),
          ),
          const SizedBox(width: 10),
          OpenContainer(
            openBuilder: (context, _) => const DrawingPad(),
            closedShape: const CircleBorder(),
            closedBuilder: (context, VoidCallback openContainer) => const CircleAvatar(
              radius: 25,
              child: Icon(Icons.draw_outlined),
            ),
          ),
        ],
      ),
    );
  }
}

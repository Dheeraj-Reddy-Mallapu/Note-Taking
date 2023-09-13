import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:note_taking_firebase/screens/notes/edit_note.dart';
import 'package:note_taking_firebase/screens/notes/notes.dart';
import 'package:note_taking_firebase/services/firestore.dart';
import 'package:note_taking_firebase/widgets/notes_ui.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;

class MyListView extends StatelessWidget {
  const MyListView({super.key, required this.filteredNotes, required this.searchInput, required this.fav});
  final List<Map<String, dynamic>> filteredNotes;
  final String searchInput;
  final bool fav;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
        child: ListView.builder(
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) {
        final data = filteredNotes[index];
        final decodeContent = jsonDecode(utf8.decode(base64Url.decode(data['content'])));
        q.QuillController content = q.QuillController(
          document: q.Document.fromJson(decodeContent),
          selection: const TextSelection.collapsed(offset: 0),
        );
        if (data['color'] == null) {
          db.collection(user.uid).doc(data['id']).update({'color': 0});
          return const Notes();
        }
        if (searchInput.isEmpty) {
          return AnimationConfiguration.staggeredList(
            position: index,
            child: SlideAnimation(
              duration: const Duration(milliseconds: 1500),
              curve: Curves.fastLinearToSlowEaseIn,
              horizontalOffset: 30,
              verticalOffset: 300,
              child: FlipAnimation(
                duration: const Duration(milliseconds: 1800),
                curve: Curves.fastLinearToSlowEaseIn,
                flipAxis: FlipAxis.y,
                child: NotesUI(
                  data: data,
                  content: content,
                  openNote: EditNote(data: data, content: content),
                  index: index,
                ),
              ),
            ),
          );
        }
        if (utf8.decode(base64Url.decode(data['title'])).toString().toLowerCase().contains(searchInput.toLowerCase())) {
          return AnimationConfiguration.staggeredList(
            position: index,
            child: SlideAnimation(
              duration: const Duration(milliseconds: 1200),
              curve: Curves.fastLinearToSlowEaseIn,
              horizontalOffset: 30,
              verticalOffset: 300,
              child: FlipAnimation(
                duration: const Duration(milliseconds: 1440),
                curve: Curves.fastLinearToSlowEaseIn,
                flipAxis: FlipAxis.y,
                child: NotesUI(
                  data: data,
                  content: content,
                  openNote: EditNote(data: data, content: content),
                  index: index,
                ),
              ),
            ),
          );
        }
        if (fav == true) {
          return AnimationConfiguration.staggeredList(
            position: index,
            delay: const Duration(milliseconds: 100),
            child: SlideAnimation(
              duration: const Duration(milliseconds: 1500),
              curve: Curves.fastLinearToSlowEaseIn,
              horizontalOffset: 30,
              verticalOffset: 300,
              child: FlipAnimation(
                duration: const Duration(milliseconds: 1800),
                curve: Curves.fastLinearToSlowEaseIn,
                flipAxis: FlipAxis.y,
                child: NotesUI(
                  data: data,
                  content: content,
                  openNote: EditNote(data: data, content: content),
                  index: index,
                ),
              ),
            ),
          );
        }
        return null;
      },
    ));
  }
}

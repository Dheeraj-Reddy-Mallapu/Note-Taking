import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:note_taking_firebase/objects/drawing_note.dart';
import 'package:note_taking_firebase/objects/text_note.dart';
import 'package:note_taking_firebase/screens/drawings/drawing_pad.dart';
import 'package:note_taking_firebase/screens/notes/edit_note.dart';
import 'package:note_taking_firebase/widgets/drawing_ui.dart';
import 'package:note_taking_firebase/widgets/notes_ui.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;

class MyListView extends StatelessWidget {
  const MyListView({super.key, required this.filteredDocs, required this.searchInput, required this.fav});
  final List<Map<String, dynamic>> filteredDocs;
  final String searchInput;
  final bool fav;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
        child: ListView.builder(
      itemCount: filteredDocs.length,
      itemBuilder: (context, index) {
        late dynamic data;

        String docType = filteredDocs[index]['type'] ?? 'note';
        if (docType == 'note') {
          data = TextNote.fromMap(filteredDocs[index]);
        } else {
          data = DrawingNote.fromMap(filteredDocs[index]);
        }

        late dynamic decodeContent;
        late q.QuillController content;

        if (data is TextNote) {
          decodeContent = jsonDecode(data.content);
          content = q.QuillController(
            document: q.Document.fromJson(decodeContent),
            selection: const TextSelection.collapsed(offset: 0),
          );
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
                child: data is TextNote
                    ? NotesUI(
                        data: data,
                        content: content,
                        openNote: EditNote(data: data, content: content),
                        index: index,
                      )
                    : DrawingUI(data: data, openNote: DrawingPad(isEditMode: true, drawing: data)),
              ),
            ),
          );
        }
        if (data.title.toLowerCase().contains(searchInput.toLowerCase())) {
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
                child: data is TextNote
                    ? NotesUI(
                        data: data,
                        content: content,
                        openNote: EditNote(data: data, content: content),
                        index: index,
                      )
                    : DrawingUI(data: data, openNote: DrawingPad(isEditMode: true, drawing: data)),
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
                child: data is TextNote
                    ? NotesUI(
                        data: data,
                        content: content,
                        openNote: EditNote(data: data, content: content),
                        index: index,
                      )
                    : DrawingUI(data: data, openNote: DrawingPad(isEditMode: true, drawing: data)),
              ),
            ),
          );
        }
        return null;
      },
    ));
  }
}

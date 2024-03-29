import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:note_taking_firebase/objects/drawing_note.dart';
import 'package:note_taking_firebase/objects/note.dart';
import 'package:note_taking_firebase/objects/text_note.dart';
import 'package:note_taking_firebase/screens/drawings/drawing_pad.dart';
import 'package:note_taking_firebase/screens/notes/edit_note.dart';
import 'package:note_taking_firebase/screens/notes/view_note.dart';
import 'package:note_taking_firebase/widgets/drawing_ui.dart';
import 'package:note_taking_firebase/widgets/notes_ui.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;

class MyGridView extends StatelessWidget {
  const MyGridView({super.key, required this.filteredDocs, required this.fav, required this.isBin});
  final List<Map<String, dynamic>> filteredDocs;
  final bool fav;
  final bool isBin;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double childAspectRatio = 3 / 5;
    int crossAxisCount = 2;
    if (size > 580 && size <= 720) {
      childAspectRatio = 4 / 5;
      crossAxisCount = 3;
    } else if (size > 720 && size <= 880) {
      childAspectRatio = 5 / 6;
      crossAxisCount = 4;
    } else if (size > 880 && size <= 1080) {
      childAspectRatio = 6 / 7;
      crossAxisCount = 5;
    } else if (size > 1080 && size <= 1320) {
      childAspectRatio = 7 / 8;
      crossAxisCount = 6;
    } else if (size > 1320) {
      childAspectRatio = 8 / 9;
      crossAxisCount = 7;
    }

    return AnimationLimiter(
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        children: List.generate(
          filteredDocs.length,
          (index) {
            late Note data;

            String docType = filteredDocs[index]['type'] ?? 'note';
            if (docType == 'note') {
              data = TextNote.fromMap(filteredDocs[index]);
            } else {
              data = DrawingNote.fromMap(filteredDocs[index]);
            }

            late q.QuillController content;

            if (data is TextNote) {
              final decodeContent = jsonDecode(data.content);
              content = q.QuillController(
                document: q.Document.fromJson(decodeContent),
                selection: const TextSelection.collapsed(offset: 0),
              );
            }

            Widget openNote = data is TextNote
                ? EditNote(data: data, content: content)
                : DrawingPad(isEditMode: true, drawing: data as DrawingNote);
            if (isBin == true) {
              openNote = data is TextNote
                  ? ViewNote(data: data, content: content)
                  : DrawingPad(isEditMode: true, drawing: data as DrawingNote);
            } else {
              openNote = data is TextNote
                  ? EditNote(data: data, content: content)
                  : DrawingPad(isEditMode: true, drawing: data as DrawingNote);
            }

            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: crossAxisCount,
              duration: const Duration(milliseconds: 500),
              child: ScaleAnimation(
                duration: const Duration(milliseconds: 900),
                curve: Curves.fastLinearToSlowEaseIn,
                child: FadeInAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: data is TextNote
                      ? NotesUI(
                          data: data,
                          content: content,
                          openNote: openNote,
                          index: index,
                        )
                      : DrawingUI(
                          data: data as DrawingNote,
                          openNote: openNote,
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

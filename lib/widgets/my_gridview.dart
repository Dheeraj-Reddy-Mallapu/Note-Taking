import 'dart:convert';

import 'package:flutter/material.dart';
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
  const MyGridView({super.key, required this.notes, required this.isBin});
  final List<Map<String, dynamic>> notes;
  final bool isBin;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: notes.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 250),
      itemBuilder: (context, index) {
        late Note data;

        String docType = notes[index]['type'] ?? 'note';
        if (docType == 'note') {
          data = TextNote.fromMap(notes[index]);
        } else {
          data = DrawingNote.fromMap(notes[index]);
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

        return data is TextNote
            ? NotesUI(
                data: data,
                content: content,
                openNote: openNote,
                index: index,
              )
            : DrawingUI(
                data: data as DrawingNote,
                openNote: openNote,
              );
      },
    );
  }
}

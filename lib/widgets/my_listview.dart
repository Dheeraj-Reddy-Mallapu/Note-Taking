import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:note_taking_firebase/objects/drawing_note.dart';
import 'package:note_taking_firebase/objects/text_note.dart';
import 'package:note_taking_firebase/screens/drawings/drawing_pad.dart';
import 'package:note_taking_firebase/screens/notes/edit_note.dart';
import 'package:note_taking_firebase/widgets/drawing_ui.dart';
import 'package:note_taking_firebase/widgets/notes_ui.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;

class MyListView extends StatelessWidget {
  const MyListView({super.key, required this.notes});
  final List<Map<String, dynamic>> notes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        late dynamic data;

        String docType = notes[index]['type'] ?? 'note';
        if (docType == 'note') {
          data = TextNote.fromMap(notes[index]);
        } else {
          data = DrawingNote.fromMap(notes[index]);
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

        return data is TextNote
            ? NotesUI(
                data: data,
                content: content,
                openNote: EditNote(data: data, content: content),
                index: index,
              )
            : DrawingUI(data: data, openNote: DrawingPad(isEditMode: true, drawing: data));
      },
    );
  }
}

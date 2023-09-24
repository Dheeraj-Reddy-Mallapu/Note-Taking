import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:note_taking_firebase/objects/drawing.dart';
import 'package:note_taking_firebase/objects/note.dart';
import 'package:note_taking_firebase/screens/drawings/drawing_pad.dart';
import 'package:note_taking_firebase/screens/notes/edit_note.dart';
import 'package:note_taking_firebase/screens/notes/view_note.dart';
import 'package:note_taking_firebase/widgets/drawing_ui.dart';
import 'package:note_taking_firebase/widgets/notes_ui.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;

class MyGridView extends StatelessWidget {
  const MyGridView(
      {super.key, required this.filteredDocs, required this.searchInput, required this.fav, required this.isBin});
  final List<Map<String, dynamic>> filteredDocs;
  final String searchInput;
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
        children: List.generate(filteredDocs.length, (index) {
          late dynamic data;

          String docType = filteredDocs[index]['type'] ?? 'note';
          if (docType == 'note') {
            data = Note.fromMap(filteredDocs[index]);
          } else {
            data = Drawing.fromMap(filteredDocs[index]);
          }

          late dynamic decodeContent;
          late q.QuillController content;

          if (data is Note) {
            decodeContent = jsonDecode(utf8.decode(base64Url.decode(data.content)));
            content = q.QuillController(
              document: q.Document.fromJson(decodeContent),
              selection: const TextSelection.collapsed(offset: 0),
            );
          }

          if (searchInput.isEmpty) {
            Widget openNote =
                data is Note ? EditNote(data: data, content: content) : DrawingPad(isEditMode: true, drawing: data);
            if (isBin == true) {
              openNote =
                  data is Note ? ViewNote(data: data, content: content) : DrawingPad(isEditMode: true, drawing: data);
            } else {
              openNote =
                  data is Note ? EditNote(data: data, content: content) : DrawingPad(isEditMode: true, drawing: data);
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
                  child: data is Note
                      ? NotesUI(
                          data: data,
                          content: content,
                          openNote: openNote,
                          index: index,
                        )
                      : DrawingUI(data: data, openNote: openNote, index: index),
                ),
              ),
            );
          }
          if (utf8.decode(base64Url.decode(data.title)).toString().toLowerCase().contains(searchInput.toLowerCase())) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: crossAxisCount,
              duration: const Duration(milliseconds: 500),
              child: ScaleAnimation(
                duration: const Duration(milliseconds: 900),
                curve: Curves.fastLinearToSlowEaseIn,
                child: FadeInAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: data is Note
                      ? NotesUI(
                          data: data,
                          content: content,
                          openNote: EditNote(data: data, content: content),
                          index: index,
                        )
                      : DrawingUI(data: data, openNote: DrawingPad(isEditMode: true, drawing: data), index: index),
                ),
              ),
            );
          }
          if (fav == true) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: crossAxisCount,
              duration: const Duration(milliseconds: 500),
              child: ScaleAnimation(
                duration: const Duration(milliseconds: 900),
                curve: Curves.fastLinearToSlowEaseIn,
                child: FadeInAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: data is Note
                      ? NotesUI(
                          data: data,
                          content: content,
                          openNote: EditNote(data: data, content: content),
                          index: index,
                        )
                      : DrawingUI(data: data, openNote: DrawingPad(isEditMode: true, drawing: data), index: index),
                ),
              ),
            );
          }
          return const Center(child: Text('Something went wrong'));
        }),
      ),
    );
  }
}

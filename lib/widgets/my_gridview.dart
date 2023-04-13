import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:note_taking_firebase/screens/edit_note.dart';
import 'package:note_taking_firebase/screens/home_screen.dart';
import 'package:note_taking_firebase/services/database.dart';
import 'package:note_taking_firebase/widgets/notes_ui.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;

class MyGridView extends StatelessWidget {
  const MyGridView({super.key, required this.filteredNotes, required this.searchInput, required this.fav});
  final List<Map<String, dynamic>> filteredNotes;
  final String searchInput;
  final bool fav;

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
        children: List.generate(filteredNotes.length, (index) {
          final data = filteredNotes[index];
          final decodeContent = jsonDecode(utf8.decode(base64Url.decode(data['content'])));
          q.QuillController content = q.QuillController(
            document: q.Document.fromJson(decodeContent),
            selection: const TextSelection.collapsed(offset: 0),
          );
          if (data['color'] == null) {
            db.collection(user.uid).doc(data['id']).update({'color': 0});
            return const HomeScreen();
          }
          if (searchInput.isEmpty) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: crossAxisCount,
              duration: const Duration(milliseconds: 500),
              child: ScaleAnimation(
                duration: const Duration(milliseconds: 900),
                curve: Curves.fastLinearToSlowEaseIn,
                child: FadeInAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
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
          if (utf8
              .decode(base64Url.decode(data['title']))
              .toString()
              .toLowerCase()
              .contains(searchInput.toLowerCase())) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: crossAxisCount,
              duration: const Duration(milliseconds: 500),
              child: ScaleAnimation(
                duration: const Duration(milliseconds: 900),
                curve: Curves.fastLinearToSlowEaseIn,
                child: FadeInAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
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
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: crossAxisCount,
              duration: const Duration(milliseconds: 500),
              child: ScaleAnimation(
                duration: const Duration(milliseconds: 900),
                curve: Curves.fastLinearToSlowEaseIn,
                child: FadeInAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
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
          return const Center(child: Text('Something went wrong'));
        }),
      ),
    );
  }
}

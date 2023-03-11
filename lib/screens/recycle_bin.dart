import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:note_taking_firebase/screens/view_note.dart';
import 'package:note_taking_firebase/services/database.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:note_taking_firebase/widgets/notes_ui.dart';

class RecycleBin extends StatefulWidget {
  const RecycleBin({super.key});

  @override
  State<RecycleBin> createState() => _RecycleBinState();
}

class _RecycleBinState extends State<RecycleBin> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recycle Bin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: color.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FireStore().readBinNotes(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
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
              final notes = snapshot.data!;
              if (notes.isNotEmpty) {
                return GridView.builder(
                    itemCount: notes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: childAspectRatio,
                      crossAxisCount: crossAxisCount,
                    ),
                    itemBuilder: (context, idx) {
                      final data = notes[idx];
                      final decodeContent = jsonDecode(utf8.decode(base64Url.decode(data['content'])));
                      quill.QuillController content = quill.QuillController(
                        document: quill.Document.fromJson(decodeContent),
                        selection: const TextSelection.collapsed(offset: 0),
                      );
                      return NotesUI(
                        data: data,
                        content: content,
                        openNote: ViewNote(data: data, content: content),
                      );
                    });
              } else {
                return const Center(child: Text('No notes found'));
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

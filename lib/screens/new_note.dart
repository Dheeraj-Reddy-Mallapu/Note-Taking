import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:note_taking_firebase/services/database.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:random_string_generator/random_string_generator.dart';

class NewNote extends StatelessWidget {
  const NewNote({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    quill.QuillController contentController = quill.QuillController.basic();
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
          title: Text('New Note',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: color.primary,
              )),
          centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(fontSize: 20),
              minLines: 1,
              maxLines: 2,
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            quill.QuillToolbar.basic(
              controller: contentController,
              multiRowsDisplay: false,
            ),
            Expanded(
              child: quill.QuillEditor.basic(
                readOnly: false,
                controller: contentController,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  final jsonContent = jsonEncode(contentController.document.toDelta().toJson());
                  String encodedT = base64Url.encode(utf8.encode(titleController.text));
                  String encodedC = base64Url.encode(utf8.encode(jsonContent));
                  var id = RandomStringGenerator(fixedLength: 15).generate();
                  FireStore().createNote(id: id, title: encodedT, content: encodedC);
                  Navigator.pop(context);
                },
                child: const Text('SAVE'))
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:note_taking_firebase/custom_color.g.dart';
import 'package:note_taking_firebase/services/database.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:random_string_generator/random_string_generator.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final titleController = TextEditingController();
  quill.QuillController contentController = quill.QuillController.basic();
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    /*final customColor = Theme.of(context).extension<CustomColors>()!;
    int colour = color.secondaryContainer.value;

    List<Color> colours = [
      color.secondaryContainer,
      customColor.greenishblueContainer!,
      customColor.pinkishredContainer!,
      customColor.yellowishbrownContainer!,
      customColor.yellowishgreenContainer!,
    ];*/
    return Scaffold(
      appBar: AppBar(
        title: Text('New Note',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: color.primary,
            )),
        centerTitle: true,
        actions: [
          ElevatedButton(
              onPressed: () {
                final jsonContent = jsonEncode(contentController.document.toDelta().toJson());
                String encodedT = base64Url.encode(utf8.encode(titleController.text));
                String encodedC = base64Url.encode(utf8.encode(jsonContent));
                var id = RandomStringGenerator(fixedLength: 15).generate();
                FireStore().createNote(id: id, title: encodedT, content: encodedC, deleted: false /*, color: colour*/);
                Navigator.pop(context);
              },
              child: const Text('SAVE'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /*Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Text('COLOUR:'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: colours.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: InkWell(
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colours[index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),*/
            TextField(
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(fontSize: 20),
              minLines: 1,
              maxLines: 2,
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            Expanded(
              flex: 12,
              child: quill.QuillEditor.basic(
                readOnly: false,
                controller: contentController,
              ),
            ),
            quill.QuillToolbar.basic(
              controller: contentController,
              multiRowsDisplay: false,
            ),
          ],
        ),
      ),
    );
  }
}

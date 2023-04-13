import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:note_taking_firebase/custom_color.g.dart';
import 'package:note_taking_firebase/services/database.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:note_taking_firebase/widgets/my_snackbar.dart';
import 'package:random_string_generator/random_string_generator.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final titleController = TextEditingController();
  int colourIndex = 0;
  late Icon selectedIcon;
  quill.QuillController contentController = quill.QuillController.basic();

  var id = RandomStringGenerator(fixedLength: 15).generate();
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final customColor = Theme.of(context).extension<CustomColors>()!;
    List<Color> colours = [
      color.secondaryContainer,
      customColor.greenishblueContainer!,
      customColor.yellowishgreenContainer!,
      customColor.yellowishbrownContainer!,
      customColor.pinkishredContainer!,
      customColor.blueContainer!,
      customColor.purpleContainer!,
    ];
    List<Color> primaryColours = [
      color.primary,
      customColor.greenishblue!,
      customColor.yellowishgreen!,
      customColor.yellowishbrown!,
      customColor.pinkishred!,
      customColor.blue!,
      customColor.purple!,
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colours[colourIndex],
        title: Text('New Note',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: primaryColours[colourIndex],
            )),
        centerTitle: true,
        actions: [
          ElevatedButton(
              style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(primaryColours[colourIndex])),
              onPressed: () {
                final jsonContent = jsonEncode(contentController.document.toDelta().toJson());
                String encodedT = base64Url.encode(utf8.encode(titleController.text));
                String encodedC = base64Url.encode(utf8.encode(jsonContent));

                try {
                  FireStore()
                      .createNote(id: id, title: encodedT, content: encodedC, deleted: false, color: colourIndex);
                  MySnackbar().show(context, 'Successfully SAVED ✅', colours[colourIndex]);
                } catch (e) {
                  MySnackbar().show(context, e.toString(), color.errorContainer);
                }
              },
              child: const Text('SAVE'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  const Text('Colour:   '),
                  Expanded(
                    child: ListView.builder(
                      itemCount: colours.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        if (colourIndex == index) {
                          selectedIcon = const Icon(Icons.done);
                        } else {
                          selectedIcon = Icon(Icons.adjust, color: colours[index]);
                        }
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
                              child: selectedIcon,
                            ),
                            onTap: () {
                              setState(() {
                                colourIndex = index;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(fontSize: 20),
              minLines: 1,
              maxLines: 2,
              controller: titleController,
              decoration: InputDecoration(
                  hintText: 'Title',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColours[colourIndex], width: 2),
                  )),
            ),
            Expanded(
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

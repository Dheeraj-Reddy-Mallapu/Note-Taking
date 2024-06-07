import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_taking_firebase/custom_color.g.dart';
import 'package:note_taking_firebase/services/firestore.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:note_taking_firebase/widgets/my_snackbar.dart';
import 'package:random_string_generator/random_string_generator.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final titleController = TextEditingController();
  q.QuillController contentController = q.QuillController.basic();

  String savedTitle = '';
  String savedContent = '';

  String id = RandomStringGenerator(fixedLength: 15).generate();

  late Icon selectedIcon;

  int colourIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final c = NewNoteC();

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
      customColor.redContainer!,
      customColor.greenContainer!,
    ];
    List<Color> primaryColours = [
      color.primary,
      customColor.greenishblue!,
      customColor.yellowishgreen!,
      customColor.yellowishbrown!,
      customColor.pinkishred!,
      customColor.blue!,
      customColor.purple!,
      customColor.red!,
      customColor.green!,
    ];

    if (savedContent == '') {
      savedContent = jsonEncode(contentController.document.toDelta().toJson());
    }

    saveNote() async {
      final jsonContent =
          jsonEncode(contentController.document.toDelta().toJson());
      String encodedT = base64Url.encode(utf8.encode(titleController.text));
      String encodedC = base64Url.encode(utf8.encode(jsonContent));

      try {
        await FireStore().createNote(
            uid: user.uid,
            id: id,
            title: encodedT,
            content: encodedC,
            sentBy: '',
            deleted: false,
            color: colourIndex);
        await db.collection(user.uid).doc(id).get().then((value) {
          if (value.exists) {
            mySnackBar(
                context, 'Hurray!', 'Successfully SAVED', ContentType.success);

            savedTitle = titleController.text;
            savedContent = jsonContent;
            setState(() {});
          } else {
            mySnackBar(context, 'Oh Snap!',
                'Something went wrong. Please try again', ContentType.failure);
          }
        });
      } on FirebaseException catch (e) {
        // ignore: use_build_context_synchronously
        mySnackBar(context, 'Oh Snap!', e.toString(), ContentType.failure);
      }
    }

    return PopScope(
      canPop: !(savedContent !=
              jsonEncode(contentController.document.toDelta().toJson()) ||
          savedTitle != titleController.text),
      onPopInvoked: (_) async {
        final jsonContent =
            jsonEncode(contentController.document.toDelta().toJson());
        if (savedContent != jsonContent || savedTitle != titleController.text) {
          Get.defaultDialog(
            title: 'Save Changes',
            content: const Text(
                'Save: save changes\nDiscard: ignore changes\nCancel: do nothing'),
            actions: [
              TextButton(
                  onPressed: () => Get.back(), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  contentController.clear();
                  titleController.clear();

                  Get.back();
                  Get.back();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(color.errorContainer),
                  foregroundColor: MaterialStatePropertyAll(color.error),
                ),
                child: const Text('Discard'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await saveNote();

                  Get.back();
                  Get.back();
                },
                child: const Text('Save'),
              ),
            ],
          );
        }
      },
      child: Scaffold(
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
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStatePropertyAll(primaryColours[colourIndex])),
                onPressed: () async => await saveNote(),
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
                            selectedIcon =
                                Icon(Icons.adjust, color: colours[index]);
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
                      borderSide: BorderSide(
                          color: primaryColours[colourIndex], width: 2),
                    )),
              ),
              Expanded(
                child: q.QuillEditor.basic(
                  configurations: q.QuillEditorConfigurations(
                    controller: contentController,
                    readOnly: false,
                  ),
                ),
              ),
              // if (!kIsWeb)
              q.QuillToolbar.simple(
                configurations: q.QuillSimpleToolbarConfigurations(
                  controller: contentController,
                  multiRowsDisplay: kIsWeb ? true : false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class NewNoteC extends GetxController {
//   RxInt colourIndex = 0.obs;
// }

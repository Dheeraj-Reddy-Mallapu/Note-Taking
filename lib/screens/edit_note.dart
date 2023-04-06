import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:note_taking_firebase/custom_color.g.dart';
import 'package:note_taking_firebase/services/database.dart';
import 'package:note_taking_firebase/widgets/my_snackbar.dart';
import 'package:random_string_generator/random_string_generator.dart';

class EditNote extends StatefulWidget {
  const EditNote({super.key, required this.data, required this.content});
  final Map<String, dynamic> data;
  final quill.QuillController content;

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late String isFav;
  late bool fav;
  late Icon favIcon;
  String id = RandomStringGenerator(fixedLength: 15).generate();

  int colourIndex = 0;
  late Icon selectedIcon;
  int dummy = 0;
  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    quill.QuillController contentController = quill.QuillController.basic();
    titleController.text = utf8.decode(base64Url.decode(widget.data['title']));
    final decodeJson = jsonDecode(utf8.decode(base64Url.decode(widget.data['content'])));
    contentController = quill.QuillController(
      document: quill.Document.fromJson(decodeJson),
      selection: const TextSelection.collapsed(offset: 0),
    );

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
    if (dummy == 0) {
      colourIndex = widget.data['color'];
    }

    if (widget.data['isFav'] != null && dummy == 0) {
      setState(() {
        isFav = widget.data['isFav'];
        if (widget.data['isFav'] == 'true') {
          fav = true;
          favIcon = const Icon(Icons.favorite, color: Colors.redAccent);
        }
        if (widget.data['isFav'] == 'false') {
          fav = false;
          favIcon = const Icon(Icons.favorite_border);
        }
      });
    } else if (widget.data['isFav'] == null && dummy == 0) {
      setState(() {
        isFav = 'false';
        fav = false;
        favIcon = const Icon(Icons.favorite_border);
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colours[colourIndex],
        title: Text(
          'Edit Note',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: primaryColours[colourIndex],
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                final jsonContent = jsonEncode(contentController.document.toDelta().toJson());
                String encodedT = base64Url.encode(utf8.encode(titleController.text));
                String encodedC = base64Url.encode(utf8.encode(jsonContent));
                try {
                  FireStore().updateNote(id: widget.data['id'], title: encodedT, content: encodedC, color: colourIndex);
                  MySnackbar().show(context, 'Successfully SAVED ✅', colours[colourIndex]);
                } catch (e) {
                  MySnackbar().show(context, e.toString(), color.errorContainer);
                }
              },
              child: Text(
                'SAVE',
                style: TextStyle(color: primaryColours[colourIndex]),
              )),
          PopupMenuButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text(
                      'Delete',
                      style: TextStyle(color: color.error),
                    ),
                    onTap: () {
                      try {
                        FireStore()
                            .createBinNote(id: widget.data['id'], deleted: true)
                            .whenComplete(() => Navigator.pop(context));
                        MySnackbar().show(context, 'Moved to Recycle Bin ✅', colours[colourIndex]);
                      } catch (e) {
                        MySnackbar().show(context, e.toString(), color.errorContainer);
                      }
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Details'),
                    onTap: () => showBottomSheet(
                      context: context,
                      builder: (context) {
                        return ListView(
                          children: [
                            ListTile(
                              title: const Text("Created at:"),
                              subtitle: Text(widget.data['createdAt']),
                            ),
                            ListTile(
                              title: const Text("Last edited:"),
                              subtitle: Text(widget.data['modifiedAt']),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ];
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                dummy++;
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(fontSize: 20),
                    minLines: 1,
                    maxLines: 2,
                    controller: titleController,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (isFav == 'false') {
                      setState(() {
                        isFav = 'true';
                        favIcon = const Icon(Icons.favorite, color: Colors.redAccent);
                        dummy++;
                      });
                      MySnackbar().show(context, 'Added to Favorites ✅', colours[colourIndex]);
                    } else if (isFav == 'true') {
                      setState(() {
                        isFav = 'false';
                        favIcon = const Icon(Icons.favorite_border);
                        dummy++;
                      });
                      MySnackbar().show(context, 'Removed from Favorites ❌', color.secondaryContainer);
                    }
                    db.collection(user.uid).doc(widget.data['id']).update({'isFav': isFav});
                  },
                  icon: favIcon,
                ),
              ],
            ),
            Expanded(
              child: quill.QuillEditor(
                expands: true,
                padding: const EdgeInsets.all(2),
                focusNode: FocusNode(),
                scrollController: ScrollController(),
                scrollable: true,
                autoFocus: false,
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

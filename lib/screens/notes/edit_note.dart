import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:get/get.dart';
import 'package:note_taking_firebase/custom_color.g.dart';
import 'package:note_taking_firebase/objects/text_note.dart';
import 'package:note_taking_firebase/services/firestore.dart';
import 'package:note_taking_firebase/widgets/my_snackbar.dart';
import 'package:random_string_generator/random_string_generator.dart';

class EditNote extends StatefulWidget {
  const EditNote({super.key, required this.data, required this.content});
  final TextNote data;
  final q.QuillController content;

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final titleController = TextEditingController();
  q.QuillController contentController = q.QuillController.basic();
  late bool isFav;
  late bool fav;
  late Icon favIcon;
  final dB = FireStore();

  int colourIndex = 0;
  late Icon selectedIcon;

  @override
  void initState() {
    titleController.text = widget.data.title;
    final decodeJson = jsonDecode(widget.data.content);
    contentController = q.QuillController(
      document: q.Document.fromJson(decodeJson),
      selection: const TextSelection.collapsed(offset: 0),
    );
    colourIndex = widget.data.color;
    isFav = widget.data.isFav;
    if (widget.data.isFav == true) {
      fav = true;
      favIcon = const Icon(Icons.favorite, color: Colors.redAccent);
    }
    if (widget.data.isFav == false) {
      fav = false;
      favIcon = const Icon(Icons.favorite_border);
    }

    super.initState();
  }

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
              onPressed: () async {
                final jsonContent =
                    jsonEncode(contentController.document.toDelta().toJson());
                String encodedT =
                    base64Url.encode(utf8.encode(titleController.text));
                String encodedC = base64Url.encode(utf8.encode(jsonContent));
                try {
                  await FireStore()
                      .updateNote(
                          id: widget.data.id,
                          title: encodedT,
                          content: encodedC,
                          color: colourIndex)
                      .whenComplete(() => mySnackBar(context, 'Hurray!',
                          'Successfully SAVED', ContentType.success));
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  mySnackBar(
                      context, 'Oh Snap!', e.toString(), ContentType.failure);
                }
              },
              child: Text(
                'SAVE',
                style: TextStyle(color: primaryColours[colourIndex]),
              )),
          PopupMenuButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
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
                            .createBinNote(id: widget.data.id, deleted: true)
                            .whenComplete(() => Get.back());
                        mySnackBar(context, 'Bye!', 'Moved to Recycle Bin',
                            ContentType.success);
                      } catch (e) {
                        mySnackBar(context, 'Oh Snap!', e.toString(),
                            ContentType.failure);
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
                              subtitle: Text(widget.data.createdAt),
                            ),
                            ListTile(
                              title: const Text("Last edited:"),
                              subtitle: Text(widget.data.modifiedAt),
                            ),
                            ListTile(
                              title: const Text("Recieved from:"),
                              subtitle: Text(widget.data.receivedFrom),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: const Text('Share'),
                    onTap: () {
                      Get.bottomSheet(
                        backgroundColor: colours[colourIndex],
                        SizedBox(
                          height: 300,
                          child: Column(
                            children: [
                              const Center(
                                  child: Text(
                                'Send to',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )),
                              Expanded(
                                child: StreamBuilder<List>(
                                    stream: dB.getFrndsList(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text(snapshot.error.toString());
                                      } else if (snapshot.hasData) {
                                        final friendsData = snapshot.data!;
                                        return ListView.builder(
                                          itemCount: friendsData.length,
                                          itemBuilder: (context, index) {
                                            final frndData = friendsData[index];
                                            return ListTile(
                                              leading: CircleAvatar(
                                                  child: Text('${index + 1}')),
                                              title: Text(frndData['frndName']),
                                              onTap: () {
                                                Get.defaultDialog(
                                                    backgroundColor:
                                                        colours[colourIndex],
                                                    title: frndData['frndName'],
                                                    content: const Text(
                                                        'Once sent it cannot be unsent.'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                              'cancel')),
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            String id =
                                                                RandomStringGenerator(
                                                                        fixedLength:
                                                                            15)
                                                                    .generate();
                                                            dB
                                                                .createNote(
                                                                    uid: frndData[
                                                                        'frndUid'],
                                                                    title: widget
                                                                        .data
                                                                        .title,
                                                                    content: widget
                                                                        .data
                                                                        .content,
                                                                    id: id,
                                                                    deleted: widget
                                                                        .data
                                                                        .deleted,
                                                                    color: widget
                                                                        .data
                                                                        .color,
                                                                    sentBy: user
                                                                            .displayName ??
                                                                        'Anonymous User')
                                                                .whenComplete(() =>
                                                                    db
                                                                        .collection(user
                                                                            .uid)
                                                                        .doc(widget
                                                                            .data
                                                                            .id)
                                                                        .update({
                                                                      'sentToID':
                                                                          frndData[
                                                                              'frndUid'],
                                                                    }));
                                                            await db
                                                                .collection(
                                                                    frndData[
                                                                        'frndUid'])
                                                                .doc(id)
                                                                .get()
                                                                .then((value) {
                                                              if (value
                                                                  .exists) {
                                                                mySnackBar(
                                                                    context,
                                                                    'Hurray!',
                                                                    'Successfully SAVED',
                                                                    ContentType
                                                                        .success);
                                                                Get.back();
                                                              } else {
                                                                mySnackBar(
                                                                    context,
                                                                    'Oops!',
                                                                    'Something went wrong. Please try again',
                                                                    ContentType
                                                                        .failure);
                                                              }
                                                            });
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                              'Send'))
                                                    ]);
                                              },
                                            );
                                          },
                                        );
                                      } else {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
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
                    if (isFav == false) {
                      setState(() {
                        isFav = true;
                        favIcon =
                            const Icon(Icons.favorite, color: Colors.redAccent);
                      });
                      mySnackBar(
                          context,
                          'Hurray!',
                          'Successfully added to Favorites',
                          ContentType.success);
                    } else if (isFav == true) {
                      setState(() {
                        isFav = true;
                        favIcon = const Icon(Icons.favorite_border);
                      });
                      mySnackBar(context, 'Hey!', 'Removed from Favorites',
                          ContentType.success);
                    }
                    db
                        .collection(user.uid)
                        .doc(widget.data.id)
                        .update({'isFav': isFav});
                  },
                  icon: favIcon,
                ),
              ],
            ),
            Expanded(
              child: q.QuillEditor(
                configurations: q.QuillEditorConfigurations(
                  controller: contentController,
                  expands: true,
                  padding: const EdgeInsets.all(2),
                  scrollable: true,
                  autoFocus: false,
                  readOnly: false,
                  paintCursorAboveText: true,
                ),
                focusNode: FocusNode(),
                scrollController: ScrollController(),
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
    );
  }
}

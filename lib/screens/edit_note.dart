import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:get/get.dart';
import 'package:note_taking_firebase/custom_color.g.dart';
import 'package:note_taking_firebase/services/database.dart';
import 'package:note_taking_firebase/widgets/my_snackbar.dart';

class EditNote extends StatefulWidget {
  const EditNote({super.key, required this.data, required this.content});
  final Map<String, dynamic> data;
  final q.QuillController content;

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final titleController = TextEditingController();
  q.QuillController contentController = q.QuillController.basic();
  late String isFav;
  late bool fav;
  late Icon favIcon;

  final dB = FireStore();

  int colourIndex = 0;
  late Icon selectedIcon;
  int dummy = 0;
  @override
  Widget build(BuildContext context) {
    if (dummy == 0) {
      titleController.text = utf8.decode(base64Url.decode(widget.data['title']));
      final decodeJson = jsonDecode(utf8.decode(base64Url.decode(widget.data['content'])));
      contentController = q.QuillController(
        document: q.Document.fromJson(decodeJson),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

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
              onPressed: () async {
                final jsonContent = jsonEncode(contentController.document.toDelta().toJson());
                String encodedT = base64Url.encode(utf8.encode(titleController.text));
                String encodedC = base64Url.encode(utf8.encode(jsonContent));
                try {
                  await FireStore()
                      .updateNote(id: widget.data['id'], title: encodedT, content: encodedC, color: colourIndex)
                      .whenComplete(() => MySnackbar().show(context, 'SAVED ✅', colours[colourIndex]));
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
                            if (widget.data['sentBy'] != null && widget.data['sentBy'] != '')
                              ListTile(
                                title: const Text("Recieved from:"),
                                subtitle: Text(widget.data['sentBy']),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: const Text('Share'),
                    onTap: () {
                      showBottomSheet(
                        backgroundColor: colours[colourIndex],
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 300,
                            child: Column(
                              children: [
                                const Center(
                                    child: Text(
                                  'Send to',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                                                leading: CircleAvatar(child: Text('${index + 1}')),
                                                title: Text(frndData['frndName']),
                                                onTap: () {
                                                  Get.defaultDialog(
                                                      backgroundColor: colours[colourIndex],
                                                      title: frndData['frndName'],
                                                      content: const Text('Once sent it cannot be unsent.'),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: const Text('cancel')),
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              dB.createNote(
                                                                  uid: frndData['frndUid'],
                                                                  title: widget.data['title'],
                                                                  content: widget.data['content'],
                                                                  id: widget.data['id'],
                                                                  deleted: widget.data['deleted'],
                                                                  color: widget.data['color'],
                                                                  sentBy: user.uid);
                                                            },
                                                            child: const Text('Send'))
                                                      ]);
                                                },
                                              );
                                            },
                                          );
                                        } else {
                                          return const Center(child: CircularProgressIndicator());
                                        }
                                      }),
                                ),
                              ],
                            ),
                          );
                        },
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
              child: q.QuillEditor(
                expands: true,
                padding: const EdgeInsets.all(2),
                focusNode: FocusNode(),
                scrollController: ScrollController(),
                scrollable: true,
                autoFocus: false,
                readOnly: false,
                paintCursorAboveText: true,
                controller: contentController,
              ),
            ),
            if (!kIsWeb)
              q.QuillToolbar.basic(
                controller: contentController,
                multiRowsDisplay: false,
              ),
            if (kIsWeb)
              q.QuillToolbar.basic(
                controller: contentController,
                multiRowsDisplay: true,
              ),
          ],
        ),
      ),
    );
  }
}

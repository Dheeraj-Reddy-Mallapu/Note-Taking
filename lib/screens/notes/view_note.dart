import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';
import 'package:note_taking_firebase/objects/note.dart';
import 'package:note_taking_firebase/services/firestore.dart';
import 'package:note_taking_firebase/widgets/my_snackbar.dart';

class ViewNote extends StatelessWidget {
  const ViewNote({super.key, required this.data, required this.content});
  final Note data;
  final quill.QuillController content;

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    quill.QuillController contentController = quill.QuillController.basic();
    titleController.text = utf8.decode(base64Url.decode(data.title));
    final decodeJson = jsonDecode(utf8.decode(base64Url.decode(data.content)));
    contentController = quill.QuillController(
      document: quill.Document.fromJson(decodeJson),
      selection: const TextSelection.collapsed(offset: 0),
    );

    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Note',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: color.primary,
          ),
        ),
        centerTitle: true,
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.error,
            child: IconButton(
              iconSize: 16,
              color: Colors.white,
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Delete Permanently',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete the note permanently?'),
                    actions: [
                      TextButton(onPressed: () => Get.back(), child: const Text('No')),
                      ElevatedButton(
                        onPressed: () {
                          FireStore().deleteNote(id: data.id).then((value) => Get.back());
                          mySnackBar(context, 'Hey!', 'Deleted the note permanently!', ContentType.warning);
                          Get.back();
                          Get.back();
                        },
                        child: const Text('Yes', style: TextStyle(color: Colors.deepOrange)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("(Created at: ${data.createdAt})"),
            Text("(Modified at: ${data.modifiedAt})"),
            TextField(
              style: const TextStyle(fontSize: 20),
              minLines: 1,
              maxLines: 2,
              readOnly: true,
              controller: titleController,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            Expanded(
              child: quill.QuillEditor(
                expands: true,
                padding: const EdgeInsets.all(2),
                focusNode: FocusNode(),
                scrollController: ScrollController(),
                scrollable: true,
                autoFocus: false,
                readOnly: true,
                showCursor: false,
                controller: contentController,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  FireStore().restoreNote(id: data.id, deleted: false);
                  mySnackBar(context, 'Hurray!', 'Successfully restored the Note', ContentType.success);
                  Get.back();
                  Get.back();
                },
                child: const Text('Restore Note'))
          ],
        ),
      ),
    );
  }
}

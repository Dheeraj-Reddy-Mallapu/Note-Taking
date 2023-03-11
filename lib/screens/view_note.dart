import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:note_taking_firebase/services/database.dart';
import 'package:note_taking_firebase/widgets/my_snackbar.dart';

class ViewNote extends StatelessWidget {
  const ViewNote({super.key, required this.data, required this.content});
  final Map<String, dynamic> data;
  final quill.QuillController content;

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    quill.QuillController contentController = quill.QuillController.basic();
    titleController.text = utf8.decode(base64Url.decode(data['title']));
    final decodeJson = jsonDecode(utf8.decode(base64Url.decode(data['content'])));
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
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
                      ElevatedButton(
                        onPressed: () {
                          FireStore().deleteBinNote(id: data['id']).then((value) => Navigator.pop(context));
                          MySnackbar().show(context, 'Deleted the note permanently!');
                          Navigator.pop(context);
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
            Text("(Created at: ${data['createdAt']})"),
            Text("(Modified at: ${data['modifiedAt']})"),
            TextField(
              style: const TextStyle(fontSize: 20),
              minLines: 1,
              maxLines: 2,
              readOnly: true,
              controller: titleController,
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
                  final jsonContent = jsonEncode(contentController.document.toDelta().toJson());
                  String encodedT = base64Url.encode(utf8.encode(titleController.text));
                  String encodedC = base64Url.encode(utf8.encode(jsonContent));
                  FireStore().restoreNote(
                    id: data['id'],
                    title: encodedT,
                    content: encodedC,
                    createdAt: data['createdAt'],
                    modifiedAt: data['modifiedAt'],
                  );
                  FireStore().deleteBinNote(id: data['id']);
                  MySnackbar().show(context, 'Restored the Note');
                  Navigator.pop(context);
                },
                child: const Text('Restore Note'))
          ],
        ),
      ),
    );
  }
}

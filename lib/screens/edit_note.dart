import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
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
  String id = RandomStringGenerator(fixedLength: 15).generate();
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
    if (widget.data['isFav'] != null) {
      setState(() {
        isFav = widget.data['isFav'];
      });
    } else if (widget.data['isFav'] == null) {
      setState(() {
        isFav = 'false';
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Note',
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
              tooltip: 'Move to Bin',
              onPressed: () {
                String title = '';
                if (titleController.text.isNotEmpty) {
                  title = base64Url.encode(utf8.encode(titleController.text));
                }
                final jsonContent = jsonEncode(contentController.document.toDelta().toJson());
                FireStore().createBinNote(
                  title: title,
                  content: base64Url.encode(utf8.encode(jsonContent)),
                  id: id,
                  createdAt: widget.data['createdAt'],
                  modifiedAt: widget.data['modifiedAt'],
                );
                FireStore().deleteNote(id: widget.data['id']);
                MySnackbar().show(context, 'Moved to Recycle Bin');
                Navigator.pop(context);
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
            Text("(Created at: ${widget.data['createdAt']})"),
            Text("(Modified at: ${widget.data['modifiedAt']})"),
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
                      isFav = 'true';
                      MySnackbar().show(context, 'Added to Favorites');
                    } else if (isFav == 'true') {
                      isFav = 'false';
                      MySnackbar().show(context, 'Removed from Favorites');
                    }
                    db.collection(user.uid).doc(widget.data['id']).update({'isFav': isFav});
                  },
                  icon: const Icon(Icons.favorite),
                ),
              ],
            ),
            quill.QuillToolbar.basic(
              controller: contentController,
              multiRowsDisplay: false,
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
            ElevatedButton(
                onPressed: () {
                  final jsonContent = jsonEncode(contentController.document.toDelta().toJson());
                  String encodedT = base64Url.encode(utf8.encode(titleController.text));
                  String encodedC = base64Url.encode(utf8.encode(jsonContent));
                  FireStore().updateNote(id: widget.data['id'], title: encodedT, content: encodedC);
                  Navigator.pop(context);
                },
                child: const Text('SAVE'))
          ],
        ),
      ),
    );
  }
}

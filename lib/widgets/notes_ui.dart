import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class NotesUI extends StatelessWidget {
  const NotesUI({super.key, required this.data, required this.content, required this.openNote});
  final Map<String, dynamic> data;
  final quill.QuillController content;
  final Widget openNote;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: color.primary,
                offset: const Offset(0, 2),
              )
            ],
            border: Border.all(
              width: 0.5,
              color: color.primary,
            ),
            borderRadius: BorderRadius.circular(15),
            color: color.secondaryContainer,
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => openNote,
                ),
              );
            },
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      utf8.decode(base64Url.decode(data['title'])),
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: color.tertiary,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: color.primary,
                thickness: 0.5,
              ),
              Expanded(
                child: quill.QuillEditor(
                  focusNode: FocusNode(),
                  scrollController: ScrollController(),
                  scrollable: true,
                  padding: const EdgeInsets.all(1.0),
                  autoFocus: false,
                  expands: true,
                  showCursor: false,
                  readOnly: true,
                  controller: content,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

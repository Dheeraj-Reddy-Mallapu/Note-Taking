import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:note_taking_firebase/custom_color.g.dart';

class NotesUI extends StatelessWidget {
  const NotesUI({super.key, required this.data, required this.content, required this.openNote});
  final Map<String, dynamic> data;
  final quill.QuillController content;
  final Widget openNote;

  @override
  Widget build(BuildContext context) {
    String title = utf8.decode(base64Url.decode(data['title']));

    final color = Theme.of(context).colorScheme;
    final customColor = Theme.of(context).extension<CustomColors>()!;
    List<Color> colours = [
      color.secondaryContainer,
      customColor.greenishblueContainer!,
      customColor.yellowishgreenContainer!,
      customColor.yellowishbrownContainer!,
      customColor.pinkishredContainer!,
    ];
    List<Color> primaryColours = [
      color.primary,
      customColor.greenishblue!,
      customColor.yellowishgreen!,
      customColor.yellowishbrown!,
      customColor.pinkishred!,
    ];
    int colourIndex = data['color'];

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
                color: primaryColours[colourIndex],
                offset: const Offset(0, 2),
              )
            ],
            border: Border.all(
              width: 0.5,
              color: primaryColours[colourIndex],
            ),
            borderRadius: BorderRadius.circular(15),
            color: colours[colourIndex].withOpacity(0.9),
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
              if (title.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        title,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: primaryColours[colourIndex],
                        ),
                      ),
                    ),
                  ),
                ),
              if (title.isNotEmpty)
                Divider(
                  height: 1,
                  color: primaryColours[colourIndex],
                  thickness: 0.5,
                ),
              Expanded(
                child: quill.QuillEditor(
                  padding: const EdgeInsets.all(2.0),
                  focusNode: FocusNode(),
                  scrollController: ScrollController(),
                  scrollable: true,
                  autoFocus: false,
                  expands: true,
                  readOnly: true,
                  enableInteractiveSelection: false,
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

import 'dart:convert';
import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:note_taking_firebase/custom_color.g.dart';

class NotesUI extends StatelessWidget {
  const NotesUI({
    super.key,
    required this.data,
    required this.content,
    required this.openNote,
    required this.index,
  });
  final Map<String, dynamic> data;
  final quill.QuillController content;
  final Widget openNote;
  final int index;

  @override
  Widget build(BuildContext context) {
    String title = utf8.decode(base64Url.decode(data['title']));

    final color = Theme.of(context).colorScheme;
    double size = MediaQuery.of(context).size.width;

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
    int colourIndex = data['color'];
    double listHeight = 200;
    if (kIsWeb && size > 880) {
      listHeight = 300;
    }

    return SizedBox(
      height: listHeight,
      child: OpenContainer(
        openBuilder: (context, _) => openNote,
        closedShape: const Border(),
        closedColor: color.background,
        closedBuilder: (context, VoidCallback openContainer) => Padding(
          padding: const EdgeInsets.all(6.0),
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

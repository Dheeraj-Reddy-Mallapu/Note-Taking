import 'dart:convert';
import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:note_taking_firebase/custom_color.g.dart';
import 'package:note_taking_firebase/objects/drawing_note.dart';

class DrawingUI extends StatefulWidget {
  const DrawingUI({super.key, required this.data, required this.openNote});
  final DrawingNote data;
  final Widget openNote;
  // final int index;

  @override
  State<DrawingUI> createState() => _DrawingUIState();
}

class _DrawingUIState extends State<DrawingUI> {
  GlobalKey boxSizeKey = GlobalKey();
  final DrawingController drawingC = DrawingController();

  Future<void> loadDrawingFromURL() async {
    drawingC.clear();
    final url = widget.data.url;

    final jsonFile = await DefaultCacheManager().getSingleFile(url);
    final jsonString = await jsonFile.readAsString();

    final List<dynamic> jsonList = json.decode(jsonString);

    for (final map in jsonList) {
      final steps = map['path']['steps'];

      for (final step in steps) {
        step['x'] = step['x'] / 2;

        step['y'] = step['y'] / 2;
      }

      map['paint']['strokeWidth'] = map['paint']['strokeWidth'] / 2;
    }

    for (final paintContent in jsonList) {
      if (paintContent['type'] == 'SimpleLine') {
        drawingC.addContent(SimpleLine.fromJson(paintContent));
      } else if (paintContent['type'] == 'Eraser') {
        drawingC.addContent(Eraser.fromJson(paintContent));
      }
    }
    // setState(() {});
  }

  @override
  void initState() {
    // loadDrawingFromURL();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadDrawingFromURL();
    String title = widget.data.title;

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
    int colourIndex = widget.data.color;
    double listHeight = 200;
    if (kIsWeb && size > 880) {
      listHeight = 300;
    }

    return SizedBox(
      height: listHeight,
      child: OpenContainer(
        openBuilder: (context, _) => widget.openNote,
        closedShape: const Border(),
        closedColor: color.background,
        closedBuilder: (context, VoidCallback openContainer) => Padding(
          padding: const EdgeInsets.all(8.0),
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
                child: LayoutBuilder(
                  builder: (context, constraints) => IgnorePointer(
                    child: DrawingBoard(
                      controller: drawingC,
                      background: SizedBox(height: constraints.maxHeight, width: constraints.maxWidth),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:note_taking_firebase/objects/drawing.dart';
import 'package:note_taking_firebase/services/firestore.dart';
import 'package:note_taking_firebase/services/storage.dart';
import 'package:note_taking_firebase/widgets/my_snackbar.dart';
import 'package:random_string_generator/random_string_generator.dart';

class DrawingPad extends StatefulWidget {
  const DrawingPad({super.key, this.isEditMode, this.drawing});
  final bool? isEditMode;
  final Drawing? drawing;

  @override
  DrawingPadState createState() => DrawingPadState();
}

class DrawingPadState extends State<DrawingPad> {
  Color selectedStrokeColor = Colors.black;
  Color selectedCanvasColor = Colors.white;
  double strokeWidth = 5.0;
  bool isEraseMode = false;

  final DrawingController drawingC = DrawingController();

  TextEditingController titleController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();

  String id = RandomStringGenerator(fixedLength: 15, hasSymbols: false).generate();

  List<Color> colors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];

  // Function to download JSON file from a URL.
  Future<String> downloadJsonFileFromURL(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // print('Failed to download JSON file. Status code: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      // print('Error downloading JSON file: $e');
      return '';
    }
  }

  Future<void> loadDrawingFromURL() async {
    final url = widget.drawing!.url;
    final jsonString = await downloadJsonFileFromURL(url);

    final List<dynamic> jsonList = json.decode(jsonString);

    for (final map in jsonList) {
      final steps = map['path']['steps'];

      for (final step in steps) {
        if (step['x'] is int) {
          step['x'] = step['x'].toDouble();
        }
        if (step['y'] is int) {
          step['y'] = step['y'].toDouble();
        }
      }

      if (map['paint']['strokeWidth'] is int) {
        map['paint']['strokeWidth'] = map['paint']['strokeWidth'].toDouble();
      }
    }

    for (final paintContent in jsonList) {
      if (paintContent['type'] == 'SimpleLine') {
        drawingC.addContent(SimpleLine.fromJson(paintContent));
      } else if (paintContent['type'] == 'Eraser') {
        drawingC.addContent(Eraser.fromJson(paintContent));
      }
    }

    setState(() {});
  }

  saveDrawing() async {
    final drawingJson = drawingC.getJsonList();

    for (final map in drawingJson) {
      final List<Map<String, dynamic>> steps = map['path']['steps'];

      for (final step in steps) {
        if (step['x'] is int) {
          step['x'] = step['x'].toDouble();
        }
        if (step['y'] is int) {
          step['y'] = step['y'].toDouble();
        }
      }

      if (map['paint']['strokeWidth'] is int) {
        map['paint']['strokeWidth'] = map['paint']['strokeWidth'].toDouble();
      }
    }

    String downloadUrl = await saveDrawingToStorage(drawingJson, id);

    String encodedT = base64Url.encode(utf8.encode(titleController.text));

    await FireStore().saveDrawingDetails(
        isEditMode: widget.isEditMode ?? false,
        uid: user.uid,
        id: id,
        title: encodedT,
        url: downloadUrl,
        canvaColor: selectedCanvasColor.value);

    await db.collection(user.uid).doc(id).get().then((value) {
      if (value.exists) {
        mySnackBar(context, 'Hurray!', 'Successfully SAVED', ContentType.success);

        setState(() {});
      } else {
        mySnackBar(context, 'Oh Snap!', 'Something went wrong. Please try again', ContentType.failure);
      }
    });

    setState(() {});
  }

  @override
  void initState() {
    if (widget.isEditMode ?? false) {
      loadDrawingFromURL();
      titleController.text = utf8.decode(base64Url.decode(widget.drawing!.title));
      id = widget.drawing!.id;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    drawingC.setStyle(
      color: selectedStrokeColor,
      strokeWidth: strokeWidth,
    );

    return WillPopScope(
      onWillPop: () async {
        if (drawingC.getHistory.isNotEmpty) {
          Get.defaultDialog(
            title: 'Save Changes',
            content: const Text('Save: save changes\nDiscard: ignore changes\nCancel: do nothing'),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  drawingC.clear();

                  Get.back();
                  Get.back();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(color.errorContainer),
                  foregroundColor: MaterialStatePropertyAll(color.error),
                ),
                child: const Text('Discard'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await saveDrawing();

                  Get.back();
                  Get.back();
                },
                child: const Text('Save'),
              ),
            ],
          );
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: color.secondaryContainer,
          title: TextField(
            focusNode: titleFocusNode,
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Enter Title', border: InputBorder.none),
          ),
          actions: [
            IconButton(
              tooltip: 'Save',
              onPressed: () async {
                if (drawingC.getHistory.isNotEmpty && !drawingC.currentIndex.isEqual(0)) {
                  await saveDrawing();
                  setState(() {});
                }
              },
              icon: Icon(
                Icons.save,
                color: drawingC.getHistory.isEmpty || drawingC.currentIndex.isEqual(0) ? Colors.grey : null,
              ),
            ),
          ],
        ),
        body: Center(
          child: Container(
            color: selectedCanvasColor,
            height: size.height * 0.7,
            width: size.width * 0.9,
            child: DrawingBoard(
              controller: drawingC,
              onPointerDown: (p0) => setState(() {}),
              onPointerUp: (p0) => setState(() {}),
              background: Container(
                height: size.height * 0.7,
                width: size.width * 0.9,
                decoration: BoxDecoration(border: Border.all()),
              ),
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 100,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      divisions: 40,
                      label: strokeWidth == 5 ? 'Default' : strokeWidth.toString(),
                      min: 0,
                      max: 40,
                      value: strokeWidth,
                      onChanged: (val) => setState(() => strokeWidth = val),
                    ),
                  ),
                  IconButton(
                    tooltip: isEraseMode ? 'Pen' : 'Eraser',
                    onPressed: () => setState(() {
                      isEraseMode
                          ? drawingC.setPaintContent(SimpleLine())
                          : drawingC.setPaintContent(Eraser(color: selectedCanvasColor));
                      isEraseMode = !isEraseMode;
                    }),
                    icon: Icon(isEraseMode ? Icons.draw : Icons.rectangle_rounded),
                    color: color.inverseSurface,
                  ),
                  IconButton(
                    tooltip: 'Undo',
                    onPressed: () => setState(() => drawingC.undo()),
                    icon: const Icon(Icons.undo),
                    color: drawingC.currentIndex.isEqual(0) ? Colors.grey : color.inverseSurface,
                  ),
                  IconButton(
                    tooltip: 'Redo',
                    onPressed: () => setState(() => drawingC.redo()),
                    icon: const Icon(Icons.redo),
                    color: drawingC.currentIndex.isLowerThan(drawingC.getHistory.length)
                        ? color.inverseSurface
                        : Colors.grey,
                  ),
                  IconButton(
                    tooltip: 'Clear All',
                    onPressed: () => setState(() => drawingC.clear()),
                    icon: const Icon(Icons.delete_forever),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildColorPebble(selectedStrokeColor),
                  Row(
                    children: List.generate(
                      colors.length,
                      (index) => _buildColorPebble(colors[index]),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Colour Picker',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: MaterialPicker(
                              enableLabel: true,
                              pickerColor: selectedStrokeColor,
                              onColorChanged: (value) => setState(() => selectedStrokeColor = value),
                            ),
                            actions: [ElevatedButton(onPressed: () => Get.back(), child: const Text('Done'))],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.arrow_drop_up),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorPebble(Color color) {
    bool isSelected = selectedStrokeColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedStrokeColor = color),
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.blueGrey, width: 5) : null,
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:note_taking_firebase/custom_color.g.dart';
import 'package:note_taking_firebase/objects/drawing_note.dart';
import 'package:note_taking_firebase/services/firestore.dart';
import 'package:note_taking_firebase/services/storage.dart';
import 'package:note_taking_firebase/widgets/my_snackbar.dart';
import 'package:random_string_generator/random_string_generator.dart';

class DrawingPad extends StatefulWidget {
  const DrawingPad({super.key, this.isEditMode, this.drawing});
  final bool? isEditMode;
  final DrawingNote? drawing;

  @override
  DrawingPadState createState() => DrawingPadState();
}

class DrawingPadState extends State<DrawingPad> {
  Color selectedStrokeColor = Colors.black;
  Color selectedCanvasColor = Colors.white;
  double strokeWidth = 5.0;
  bool isEraseMode = false;

  bool isSaving = false;
  bool isChanged = false;
  bool isFav = false;

  int colourIndex = 0;
  late Icon selectedColorIcon;

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
    Colors.yellow.shade600,
    Colors.purple,
  ];

  Future<void> loadDrawingFromURL() async {
    final url = widget.drawing!.url;

    final jsonFile = await DefaultCacheManager().getSingleFile(url);
    final jsonString = await jsonFile.readAsString();

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
    setState(() => isSaving = true);
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
      isFav: isFav,
      color: colourIndex,
      canvaColor: selectedCanvasColor.value,
    );

    await db.collection(user.uid).doc(id).get().then((value) {
      if (value.exists) {
        mySnackBar(context, 'Hurray!', 'Successfully SAVED', ContentType.success);
        isChanged = false;

        setState(() {});
      } else {
        mySnackBar(context, 'Oh Snap!', 'Something went wrong. Please try again', ContentType.failure);
      }
    });

    setState(() => isSaving = false);
  }

  @override
  void initState() {
    if (widget.isEditMode ?? false) {
      loadDrawingFromURL();
      titleController.text = utf8.decode(base64Url.decode(widget.drawing!.title));
      id = widget.drawing!.id;
      isFav = widget.drawing!.isFav;
      colourIndex = widget.drawing!.color;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

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

    drawingC.setStyle(
      color: selectedStrokeColor,
      strokeWidth: strokeWidth,
    );

    return PopScope(
      canPop: drawingC.getHistory.isEmpty,
      onPopInvoked: (didPop) {
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
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colours[colourIndex],
          title: TextField(
            focusNode: titleFocusNode,
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Enter Title', border: InputBorder.none),
            onTapOutside: (event) => titleFocusNode.unfocus(),
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
            PopupMenuButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              itemBuilder: (context) {
                return [
                  if (widget.isEditMode ?? false)
                    PopupMenuItem(
                        child: TextButton.icon(
                            onPressed: () async {
                              if (!isFav) {
                                setState(() {
                                  isFav = true;
                                });
                                mySnackBar(context, 'Hurray!', 'Added to Favorites', ContentType.success);
                              } else {
                                setState(() {
                                  isFav = false;
                                });
                                mySnackBar(context, 'Hey!', 'Removed from Favorites', ContentType.success);
                              }
                              Get.back();
                              await db.collection(user.uid).doc(widget.drawing!.id).update({'isFav': isFav});
                            },
                            icon: Icon(isFav ? Icons.favorite : Icons.favorite_outline),
                            label: const Text('Fav'))),
                  PopupMenuItem(
                    child: Center(
                      child: Text(
                        'Theme Colour',
                        style: TextStyle(color: color.error),
                      ),
                    ),
                    onTap: () {
                      Get.defaultDialog(
                          title: 'Theme Colour:',
                          content: SizedBox(
                            height: 40.0 * colours.length,
                            child: ListView.builder(
                              itemCount: colours.length,
                              itemBuilder: (context, index) {
                                if (colourIndex == index) {
                                  selectedColorIcon = const Icon(Icons.done);
                                } else {
                                  selectedColorIcon = Icon(Icons.adjust, color: colours[index]);
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
                                      child: selectedColorIcon,
                                    ),
                                    onTap: () {
                                      Get.back();
                                      setState(() {
                                        colourIndex = index;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ));
                    },
                  ),
                  if (widget.isEditMode ?? false)
                    PopupMenuItem(
                      child: Center(
                        child: Text(
                          'Delete',
                          style: TextStyle(color: color.error),
                        ),
                      ),
                      onTap: () {
                        try {
                          FireStore().createBinNote(id: widget.drawing!.id, deleted: true).whenComplete(() {
                            drawingC.clear();
                            Get.back();
                            // Get.back();
                          });
                          mySnackBar(context, 'Bye!', 'Moved to Recycle Bin', ContentType.success);
                        } catch (e) {
                          mySnackBar(context, 'Oh Snap!', e.toString(), ContentType.failure);
                        }
                      },
                    ),
                ];
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Center(
              child: Container(
                color: selectedCanvasColor,
                height: size.height * 0.7,
                width: size.width * 0.9,
                child: DrawingBoard(
                  minScale: 0.1,
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
            if (isSaving) const Center(child: CircularProgressIndicator()),
          ],
        ),
        bottomNavigationBar: Container(
          color: colours[colourIndex],
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

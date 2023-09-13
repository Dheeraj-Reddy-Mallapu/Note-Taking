import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_taking_firebase/services/firestore.dart';
import 'package:note_taking_firebase/services/storage.dart';
import 'package:random_string_generator/random_string_generator.dart';

class NewDrawing extends StatefulWidget {
  const NewDrawing({super.key});

  @override
  NewDrawingState createState() => NewDrawingState();
}

class NewDrawingState extends State<NewDrawing> {
  Color selectedColor = Colors.black;
  Color selectedCanvasColor = Colors.white;
  double strokeWidth = 5;
  List<DrawingPoint> drawingPoints = [];
  List<DrawingPoint> lastDrawingPoints = [];
  List<List<DrawingPoint>> drawingPointsHistory = [];

  List<DrawingPoint> savedDrawingPoints = [];

  bool isNowDrawing = false;

  TextEditingController titleController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();

  List<Color> colors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.pink,
    Colors.purple,
  ];

  String id = RandomStringGenerator(fixedLength: 15, hasSymbols: false).generate();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    // print("asdfg drawingPoints = ${drawingPoints.length}");
    // print("asdfg savedDrawingPoints = ${savedDrawingPoints.length}");
    // print("asdfg lastDrawingPoints = $lastDrawingPoints\n");
    // print("asdfg drawingPointsHistory = $drawingPointsHistory");
    // print("asdfg drawingPointsHistory = ${drawingPointsHistory.length}");

    if (!isNowDrawing) {
      lastDrawingPoints = [];
    }

    return WillPopScope(
      onWillPop: () async {
        if (!listEquals(savedDrawingPoints, drawingPoints)) {
          Get.defaultDialog(
            title: 'Save Changes',
            content: const Text('Save: save changes\nDiscard: clear your drawing\nCancel: do nothing'),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  savedDrawingPoints.clear();
                  drawingPoints.clear();

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
                  savedDrawingPoints.addAll(drawingPoints);
                  String downloadUrl = await saveDrawingPointsToStorage(drawingPoints, id);

                  String encodedT = base64Url.encode(utf8.encode(titleController.text));

                  await FireStore().saveDrawingId(id: id, title: encodedT, url: downloadUrl);

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
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                if (!listEquals(savedDrawingPoints, drawingPoints)) {
                  savedDrawingPoints.addAll(drawingPoints);
                  String downloadUrl = await saveDrawingPointsToStorage(drawingPoints, id);

                  await FireStore().saveDrawingId(id: id, title: titleController.text, url: downloadUrl);
                  setState(() {});
                }
              },
              icon: Icon(
                Icons.save,
                color: listEquals(savedDrawingPoints, drawingPoints) ? Colors.grey : null,
              ),
            ),
          ],
        ),
        body: GestureDetector(
          onPanStart: (details) {
            titleFocusNode.unfocus();

            final drawingPoint = DrawingPoint(
              details.localPosition,
              Paint()
                ..color = selectedColor
                ..isAntiAlias = true
                ..strokeWidth = strokeWidth
                ..strokeCap = StrokeCap.round,
            );

            drawingPoints.add(drawingPoint);
            lastDrawingPoints.add(drawingPoint);
            setState(() {
              isNowDrawing = true;
            });
          },
          onPanUpdate: (details) {
            final drawingPoint = DrawingPoint(
              details.localPosition,
              Paint()
                ..color = selectedColor
                ..isAntiAlias = true
                ..strokeWidth = strokeWidth
                ..strokeCap = StrokeCap.round,
            );

            drawingPoints.add(drawingPoint);
            lastDrawingPoints.add(drawingPoint);
            setState(() {
              isNowDrawing = true;
            });
          },
          onPanEnd: (details) {
            final drawingPoint = DrawingPoint(const Offset(1e10000, 1e10000), Paint());

            drawingPoints.add(drawingPoint);
            lastDrawingPoints.add(drawingPoint);

            drawingPointsHistory.add(lastDrawingPoints);
            if (drawingPointsHistory.length > 25) {
              drawingPointsHistory.removeAt(0);
            }

            setState(() {
              isNowDrawing = false;
            });
          },
          child: Container(
            color: selectedCanvasColor,
            child: CustomPaint(
              painter: _DrawingPainter(drawingPoints),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
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
                    onPressed: () {
                      if (drawingPointsHistory.isNotEmpty) {
                        for (final drawingPoint in drawingPointsHistory.last) {
                          drawingPoints.remove(drawingPoint);
                        }
                        setState(() {
                          drawingPointsHistory.removeLast();
                        });
                      }
                    },
                    icon: const Icon(Icons.undo),
                    color: drawingPointsHistory.isNotEmpty ? color.inverseSurface : Colors.grey,
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      drawingPoints.clear();
                      drawingPointsHistory.clear();
                      lastDrawingPoints.clear();
                    }),
                    icon: const Icon(Icons.delete_forever),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  colors.length,
                  (index) => _buildColorChose(colors[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
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

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;

  _DrawingPainter(this.drawingPoints);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      canvas.drawLine(drawingPoints[i].offset, drawingPoints[i + 1].offset, drawingPoints[i].paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}

List<DrawingPoint> parseJsonToDrawingPoints(String jsonString) {
  final List<dynamic> jsonList = json.decode(jsonString);

  final List<DrawingPoint> drawingPoints = jsonList.map((jsonData) {
    double offsetX = jsonData['offsetX'];
    double offsetY = jsonData['offsetY'];
    final int paintColorValue = jsonData['paintColor'];

    if (offsetX == 1234567890 && offsetY == 1234567890) {
      offsetX = 1e10000;
      offsetY = 1e10000;
    }

    final Offset offset = Offset(offsetX, offsetY);
    final Paint paint = Paint()
      ..color = Color(paintColorValue)
      ..isAntiAlias = true
      ..strokeWidth = jsonData['strokeWidth']
      ..strokeCap = StrokeCap.round;

    return DrawingPoint(offset, paint);
  }).toList();

  return drawingPoints;
}

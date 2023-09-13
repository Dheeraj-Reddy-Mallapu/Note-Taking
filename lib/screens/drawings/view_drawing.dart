import 'package:flutter/material.dart';
import 'package:note_taking_firebase/screens/drawings/new_drawing.dart';
import 'package:http/http.dart' as http;

class ViewDrawing extends StatefulWidget {
  const ViewDrawing({super.key, required this.drawing});
  final Map<String, dynamic> drawing;

  @override
  ViewDrawingState createState() => ViewDrawingState();
}

class ViewDrawingState extends State<ViewDrawing> {
  Color selectedCanvasColor = Colors.white;
  List<DrawingPoint> drawingPoints = [];

  TextEditingController titleController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();

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

  Future<void> loadDrawingPointsFromURL() async {
    final url = widget.drawing['url'];
    final jsonString = await downloadJsonFileFromURL(url);

    drawingPoints = parseJsonToDrawingPoints(jsonString);
    print(drawingPoints[0]);

    setState(() {});
  }

  @override
  void initState() {
    loadDrawingPointsFromURL();
    titleController.text = widget.drawing['title'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color.secondaryContainer,
        title: TextField(
          focusNode: titleFocusNode,
          controller: titleController,
          decoration: const InputDecoration(hintText: 'Title'),
        ),
      ),
      body: Container(
        color: selectedCanvasColor,
        child: CustomPaint(
          painter: _DrawingPainter(drawingPoints),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
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

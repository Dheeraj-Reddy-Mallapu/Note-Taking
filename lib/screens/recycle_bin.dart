import 'package:flutter/material.dart';
import 'package:note_taking_firebase/services/database.dart';
import 'package:note_taking_firebase/widgets/my_gridview.dart';

class RecycleBin extends StatefulWidget {
  const RecycleBin({super.key});

  @override
  State<RecycleBin> createState() => _RecycleBinState();
}

class _RecycleBinState extends State<RecycleBin> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    List<Map<String, dynamic>> filteredNotes = notes.where((element) => element['deleted'] == true).toList();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Recycle Bin',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: color.primary,
            ),
          ),
          centerTitle: true,
        ),
        body: MyGridView(filteredNotes: filteredNotes, searchInput: '', fav: false));
  }
}

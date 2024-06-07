import 'package:flutter/material.dart';
import 'package:note_taking_firebase/provider/data_provider.dart';
import 'package:note_taking_firebase/widgets/my_gridview.dart';
import 'package:provider/provider.dart';

class RecycleBin extends StatefulWidget {
  const RecycleBin({super.key});

  @override
  State<RecycleBin> createState() => _RecycleBinState();
}

class _RecycleBinState extends State<RecycleBin> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    final dataProvider = Provider.of<DataProvider>(context, listen: true);
    List<Map<String, dynamic>> filteredNotes =
        dataProvider.allNotes.where((element) => element['deleted'] == true).toList();

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
        body: MyGridView(notes: filteredNotes, isBin: true));
  }
}

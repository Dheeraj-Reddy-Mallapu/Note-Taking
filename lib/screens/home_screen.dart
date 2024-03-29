import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_taking_firebase/provider/data_provider.dart';
import 'package:note_taking_firebase/screens/drawings/drawing_pad.dart';
import 'package:note_taking_firebase/screens/notes/new_note.dart';
import 'package:note_taking_firebase/shares_preferences.dart';
import 'package:note_taking_firebase/widgets/ad_banner.dart';
import 'package:note_taking_firebase/widgets/floating_btn.dart';
import 'package:note_taking_firebase/widgets/my_drawer.dart';
import 'package:note_taking_firebase/widgets/my_gridview.dart';
import 'package:note_taking_firebase/widgets/my_listview.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //settings
  String _orderBy = orderBy;
  bool _descending = descending;
  bool _gridview = gridview;
  bool _fav = fav;

  //for search
  final searchController = TextEditingController();

  // initialize Shared Preferences
  initSharedPrefs() async {
    _orderBy = await getOrderBy();
    _descending = await getDescending();
    _fav = await getFav();
    _gridview = await getGridview();
  }

  @override
  void initState() {
    super.initState();

    initSharedPrefs();

    //for quick actions
    const quickActions = QuickActions();

    if (!kIsWeb) {
      quickActions.setShortcutItems([
        const ShortcutItem(type: 'note', localizedTitle: 'New Note', icon: 'note'),
        const ShortcutItem(type: 'drawing', localizedTitle: 'New Drawing', icon: 'drawing'),
      ]);

      quickActions.initialize((type) {
        if (type == 'note') {
          Get.to(() => const NewNote());
        } else if (type == 'drawing') {
          Get.to(() => const DrawingPad());
        }
      });
    }
  }

  var searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    double width = MediaQuery.of(context).size.width;

    final dataProvider = Provider.of<DataProvider>(context, listen: true);

    if (width > 1080) {
      setState(() {
        _gridview = true;
        setGridview(_gridview);
      });
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: appBar(color, width),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const FloatingBtn(),
        drawer: const MyDrawer(),
        body: Stack(
          children: [
            Builder(
              builder: (context) {
                final allDocs = dataProvider.allNotes;
                List<Map<String, dynamic>> filteredDocs = [];

                if (searchController.text.isEmpty) {
                  filteredDocs = allDocs.where((element) => element['deleted'] == false).toList();
                } else {
                  final searchedDocs = allDocs
                      .where((element) => utf8
                          .decode(base64Url.decode(element['title']))
                          .toString()
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase()))
                      .toList();
                  filteredDocs = searchedDocs.where((element) => element['deleted'] == false).toList();
                }
                if (_fav == true) {
                  final favDocs = allDocs
                      .where((element) =>
                          element['isFav'] is bool ? element['isFav'] : bool.parse(element['isFav'] ?? 'false') == true)
                      .toList();
                  filteredDocs = favDocs.where((element) => element['deleted'] == false).toList();
                }

                //// Sorting
                if (_descending == false) {
                  if (_orderBy == 'modifiedAt') {
                    filteredDocs.sort((a, b) => DateTime.parse(a[_orderBy]).compareTo(DateTime.parse(b[_orderBy])));
                  } else {
                    filteredDocs.sort((a, b) => a[_orderBy].compareTo(b[_orderBy]));
                  }
                } else {
                  if (_orderBy == 'modifiedAt') {
                    filteredDocs.sort((a, b) => -DateTime.parse(a[_orderBy]).compareTo(DateTime.parse(b[_orderBy])));
                  } else {
                    filteredDocs.sort((a, b) => -a[_orderBy].compareTo(b[_orderBy]));
                  }
                }
                //// Sorting

                if (_gridview == true) {
                  if (filteredDocs.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyGridView(filteredDocs: filteredDocs, fav: _fav, isBin: false),
                    );
                  } else {
                    return const Center(child: Text('No notes found'));
                  }
                } else {
                  if (filteredDocs.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyListView(filteredDocs: filteredDocs, searchInput: searchController.text, fav: _fav),
                    );
                  } else {
                    return const Center(child: Text('No notes found'));
                  }
                }
              },
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: AdBanner(),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(ColorScheme color, double size) {
    return AppBar(
      backgroundColor: color.secondaryContainer,
      shadowColor: color.secondaryContainer,
      elevation: 5,
      title: Container(
        decoration: BoxDecoration(
          color: color.background.withOpacity(searchFocusNode.hasFocus ? 1.0 : 0.5),
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: TextField(
          focusNode: searchFocusNode,
          controller: searchController,
          onChanged: (value) => setState(() {}),
          onTapOutside: (event) => searchFocusNode.unfocus(),
          decoration: const InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
            hintText: 'Search...',
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _fav = !_fav;
              setFav(_fav);
            });
          },
          tooltip: 'Favourites',
          icon: _fav == true ? const Icon(Icons.favorite, color: Colors.red) : const Icon(Icons.favorite_border),
        ),
        PopupMenuButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          itemBuilder: ((context) {
            return [
              PopupMenuItem(
                child: SubmenuButton(
                  trailingIcon: const Icon(Icons.sort),
                  menuChildren: [
                    ExpansionTile(
                      title: const Text('Name'),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _descending = false;
                                    _orderBy = 'title';
                                    setDescending(_descending);
                                    setOrderBy(_orderBy);
                                  });
                                  Get.back();
                                },
                                child: const Text('Asc ⬆')),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _descending = true;
                                    _orderBy = 'title';
                                    setDescending(_descending);
                                    setOrderBy(_orderBy);
                                  });
                                  Get.back();
                                },
                                child: const Text('Desc ⬇'))
                          ],
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text('Modified At'),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _descending = false;
                                    _orderBy = 'modifiedAt';
                                    setDescending(_descending);
                                    setOrderBy(_orderBy);
                                  });
                                  Get.back();
                                },
                                child: const Text('Asc. ⬆')),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _descending = true;
                                    _orderBy = 'modifiedAt';
                                    setDescending(_descending);
                                    setOrderBy(_orderBy);
                                  });
                                  Get.back();
                                },
                                child: const Text('Desc. ⬇')),
                          ],
                        ),
                      ],
                    )
                  ],
                  child: const Text('Sort by:', style: TextStyle(fontSize: 16)),
                ),
              ),
              if (size < 1080)
                PopupMenuItem(
                  onTap: () {
                    if (_gridview == true) {
                      setState(() {
                        _gridview = false;
                        setGridview(_gridview);
                      });
                    } else {
                      setState(() {
                        _gridview = true;
                        setGridview(_gridview);
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(_gridview == true ? 'List View' : 'Grid View', style: const TextStyle(fontSize: 16)),
                      _gridview == true ? const Icon(Icons.list_rounded) : const Icon(Icons.grid_view_rounded),
                    ],
                  ),
                ),
            ];
          }),
          icon: const Icon(Icons.more_vert),
          tooltip: 'Options',
        ),
      ],
    );
  }
}

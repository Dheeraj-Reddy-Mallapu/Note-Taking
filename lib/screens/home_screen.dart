import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_taking_firebase/screens/drawings/drawing_pad.dart';
import 'package:note_taking_firebase/screens/notes/new_note.dart';
import 'package:note_taking_firebase/shares_preferences.dart';
import 'package:note_taking_firebase/widgets/floating_btn.dart';
import 'package:note_taking_firebase/widgets/my_drawer.dart';
import 'package:note_taking_firebase/widgets/my_gridview.dart';
import 'package:note_taking_firebase/widgets/my_listview.dart';
import 'package:quick_actions/quick_actions.dart';
import '../services/firestore.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  final titleController = TextEditingController();
  q.QuillController contentController = q.QuillController.basic();

  //settings
  String _orderBy = orderBy;
  bool _descending = descending;
  bool _gridview = gridview;
  bool _fav = fav;

  late Icon viewIcon;
  late String viewToolTip;
  Icon favIcon = const Icon(Icons.favorite_border);

  //for search
  final searchController = TextEditingController();
  String searchInput = '';

  // initialize Shared Preferences
  initSharedPrefs() async {
    _orderBy = await getOrderBy();
    _descending = await getDescending();
    _fav = await getFav();
    _gridview = await getGridview();
  }

  // for quick actions
  final quickActions = const QuickActions();

  @override
  void initState() {
    super.initState();

    initSharedPrefs();

    //for quick actions
    if (!kIsWeb) {
      quickActions.setShortcutItems([
        const ShortcutItem(type: 'note', localizedTitle: 'New Note', icon: 'add'),
        const ShortcutItem(type: 'drawing', localizedTitle: 'New Drawing', icon: 'add'),
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

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    double size = MediaQuery.of(context).size.width;

    if (_gridview == true) {
      setState(() {
        viewIcon = const Icon(Icons.list_rounded);
        viewToolTip = 'List View';
      });
    } else {
      setState(() {
        viewIcon = const Icon(Icons.grid_view_rounded);
        viewToolTip = 'Grid View';
      });
    }

    if (size > 1080) {
      setState(() {
        _gridview = true;
        viewIcon = const Icon(Icons.list_rounded);
        viewToolTip = 'List View';
        setGridview(_gridview);
      });
    }

    if (_fav == true) {
      setState(() {
        favIcon = const Icon(
          Icons.favorite,
          color: Colors.redAccent,
        );
      });
    } else {
      favIcon = const Icon(Icons.favorite_border);
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: color.secondaryContainer,
          shadowColor: color.secondaryContainer,
          elevation: 5,
          title: TextField(
            focusNode: FocusNode(),
            controller: searchController,
            onChanged: (value) => setState(() => searchInput = value),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search...',
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (_fav == false) {
                  setState(() {
                    _fav = true;
                    setFav(_fav);
                  });
                } else {
                  setState(() {
                    _fav = false;
                    setFav(_fav);
                  });
                }
              },
              tooltip: 'Favourites',
              icon: favIcon,
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
                            viewIcon = const Icon(Icons.grid_view_rounded);
                            viewToolTip = 'Grid View';
                            setGridview(_gridview);
                          });
                        } else {
                          setState(() {
                            _gridview = true;
                            viewIcon = const Icon(Icons.list_rounded);
                            viewToolTip = 'List View';
                            setGridview(_gridview);
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Text(viewToolTip, style: const TextStyle(fontSize: 16)), viewIcon],
                      ),
                    ),
                ];
              }),
              icon: const Icon(Icons.more_vert),
              tooltip: 'Options',
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const FloatingBtn(),
        drawer: const MyDrawer(),
        body: StreamBuilder<List>(
            stream: FireStore().getDocs(orderBy: _orderBy, descending: _descending),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                final docsData = snapshot.data!;
                allDocs = docsData as List<Map<String, dynamic>>;
                List<Map<String, dynamic>> filteredDocs = [];

                if (searchInput.isEmpty) {
                  filteredDocs = allDocs.where((element) => element['deleted'] == false).toList();
                } else {
                  final searchedDocs = allDocs
                      .where((element) => utf8
                          .decode(base64Url.decode(element['title']))
                          .toString()
                          .toLowerCase()
                          .contains(searchInput.toLowerCase()))
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

                // print(filteredDocs);

                if (_gridview == true) {
                  if (filteredDocs.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyGridView(filteredDocs: filteredDocs, searchInput: searchInput, fav: _fav, isBin: false),
                    );
                  } else {
                    return const Center(child: Text('No notes found'));
                  }
                } else {
                  if (filteredDocs.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyListView(filteredDocs: filteredDocs, searchInput: searchInput, fav: _fav),
                    );
                  } else {
                    return const Center(child: Text('No notes found'));
                  }
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}

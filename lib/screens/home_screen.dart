import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:note_taking_firebase/shares_preferences.dart';
import 'package:note_taking_firebase/widgets/my_gridview.dart';
import 'package:note_taking_firebase/widgets/my_list_tile.dart';
import 'package:note_taking_firebase/widgets/my_listview.dart';
import '../services/database.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:quick_actions/quick_actions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  String displayName = '';
  String photoURL = '';
  String displayEmail = '';

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

  //**for quick actions
  final quickActions = const QuickActions();
  @override
  void initState() {
    super.initState();
    quickActions.setShortcutItems([
      const ShortcutItem(type: 'note', localizedTitle: 'New Note', icon: 'add'),
    ]);
    quickActions.initialize((type) {
      if (type == 'note') {
        Navigator.pushNamed(context, 'newNote');
      }
    });
  }
  //for quick actions**

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

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
    if (user.isAnonymous) {
      displayName = 'Hello User!';
    } else {
      displayName = user.displayName!;
      photoURL = user.photoURL!;
      displayEmail = user.email!;
    }
    getOrderBy().then((value) => _orderBy);
    getDescending().then((value) => _descending);
    getGridview().then((value) => _gridview);
    getFav().then((value) => _fav);
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
            onChanged: (value) => setState(() {
              searchInput = value;
            }),
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
                                      Navigator.pop(context);
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
                                      Navigator.pop(context);
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
                                      Navigator.pop(context);
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
                                      Navigator.pop(context);
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
        /*bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.notes_rounded),
              label: 'Notes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.image),
              label: 'Drawings',
            ),
          ],
        ),*/
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          tooltip: 'New Note',
          onPressed: () => Navigator.pushNamed(context, 'newNote'),
          child: const Icon(Icons.add),
        ),
        drawer: Drawer(
          child: ListView(children: [
            UserAccountsDrawerHeader(
              accountName: Text(displayName, style: TextStyle(color: color.surface)),
              accountEmail: Text(displayEmail, style: TextStyle(color: color.surface)),
              currentAccountPicture: CircleAvatar(backgroundImage: NetworkImage(photoURL)),
            ),
            Divider(
              color: color.primary,
              thickness: 0.5,
            ),
            const MyListTile(
              toScreen: 'recycleBin',
              toScreenIcon: Icon(Icons.recycling_rounded),
              toScreenTitle: 'Recycle Bin',
            ),
            const MyListTile(
              toScreen: 'guide',
              toScreenIcon: Icon(Icons.help_outline_rounded),
              toScreenTitle: 'Guide',
            ),
            ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  showAboutDialog(
                      context: context,
                      applicationName: 'Note Taking',
                      applicationIcon: SvgPicture.asset('assets/notes.svg', height: 40),
                      children: [
                        const ListTile(
                          title: Text('Open Source Project'),
                        ),
                        const ListTile(
                          title: SelectableText('https://github.com/Dheeraj-Reddy-Mallapu'),
                        ),
                      ]);
                }),
            Divider(
              color: color.primary,
              thickness: 0.5,
            ),
          ]),
        ),
        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: StreamBuilder<List>(
              stream: FireStore().readNotes(orderBy: _orderBy, descending: _descending),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  final notesData = snapshot.data!;
                  List<Map<String, dynamic>> allNotes = notesData as List<Map<String, dynamic>>;
                  List<Map<String, dynamic>> filteredNotes = [];
                  if (searchInput.isEmpty) {
                    notes = allNotes;
                    filteredNotes = notes.where((element) => element['deleted'] == false).toList();
                  } else {
                    notes = allNotes
                        .where((element) => utf8
                            .decode(base64Url.decode(element['title']))
                            .toString()
                            .toLowerCase()
                            .contains(searchInput.toLowerCase()))
                        .toList();
                    filteredNotes = notes.where((element) => element['deleted'] == false).toList();
                  }
                  if (_fav == true) {
                    notes = allNotes.where((element) => element['isFav'] == 'true').toList();
                    filteredNotes = notes.where((element) => element['deleted'] == false).toList();
                  }
                  if (_gridview == true) {
                    if (filteredNotes.isNotEmpty) {
                      return MyGridView(filteredNotes: filteredNotes, searchInput: searchInput, fav: _fav);
                    } else {
                      return const Center(child: Text('No notes found'));
                    }
                  } else {
                    if (filteredNotes.isNotEmpty) {
                      return MyListView(filteredNotes: filteredNotes, searchInput: searchInput, fav: _fav);
                    } else {
                      return const Center(child: Text('No notes found'));
                    }
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }
}

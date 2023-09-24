// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:note_taking_firebase/screens/drawings/drawing_pad.dart';
// import 'package:note_taking_firebase/screens/drawings/drawings.dart';
// import 'package:note_taking_firebase/screens/notes/notes.dart';
// import 'package:note_taking_firebase/widgets/banner_container.dart';
// import 'package:quick_actions/quick_actions.dart';

// import 'notes/new_note.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int selectedIndex = 0;

//   List<Widget> pages = [const Notes(), const Drawings()];

//   // for quick actions
//   final quickActions = const QuickActions();

//   @override
//   void initState() {
//     //for quick actions
//     if (!kIsWeb) {
//       quickActions.setShortcutItems([
//         const ShortcutItem(type: 'note', localizedTitle: 'New Note', icon: 'add'),
//         const ShortcutItem(type: 'drawing', localizedTitle: 'New Drawing', icon: 'add'),
//       ]);

//       quickActions.initialize((type) {
//         if (type == 'note') {
//           Get.to(() => const NewNote());
//         } else if (type == 'drawing') {
//           Get.to(() => const DrawingPad());
//         }
//       });
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final color = Theme.of(context).colorScheme;

//     return Scaffold(
//       body: Stack(
//         children: [
//           IndexedStack(index: selectedIndex, children: pages),
//           if (!kIsWeb)
//             const Align(
//               alignment: Alignment.bottomCenter,
//               child: BannerContainer(),
//             )
//         ],
//       ),
//       bottomNavigationBar: NavigationBarTheme(
//         data: NavigationBarThemeData(
//           height: 50,
//           indicatorColor: color.primaryContainer,
//         ),
//         child: NavigationBar(
//           selectedIndex: selectedIndex,
//           // labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
//           destinations: const [
//             NavigationDestination(
//               icon: Icon(Icons.sticky_note_2_outlined),
//               selectedIcon: Icon(Icons.sticky_note_2),
//               label: 'Notes',
//             ),
//             NavigationDestination(
//               icon: Icon(Icons.draw_outlined),
//               selectedIcon: Icon(Icons.draw),
//               label: 'Drawings',
//             ),
//           ],
//           onDestinationSelected: (value) => setState(() => selectedIndex = value),
//         ),
//       ),
//     );
//   }
// }

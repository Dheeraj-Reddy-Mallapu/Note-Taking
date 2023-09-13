import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:note_taking_firebase/screens/drawings/drawings.dart';
import 'package:note_taking_firebase/screens/notes/notes.dart';
import 'package:note_taking_firebase/widgets/banner_container.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.pageIndex});
  final int? pageIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  List<Widget> pages = [const Notes(), const Drawings()];

  @override
  void initState() {
    if (widget.pageIndex != null) {
      selectedIndex = widget.pageIndex!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          pages.elementAt(selectedIndex),
          const Align(
            alignment: Alignment.bottomCenter,
            child: BannerContainer(),
          )
        ],
      ),
      bottomNavigationBar: GNav(
        tabs: const [
          GButton(
            icon: Icons.sticky_note_2_outlined,
            text: 'Notes',
          ),
          GButton(
            icon: Icons.draw_outlined,
            text: 'Drawings',
          ),
        ],
        selectedIndex: selectedIndex,
        onTabChange: (value) => setState(() => selectedIndex = value),
        tabMargin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        padding: const EdgeInsets.all(8),
        gap: 8,
        backgroundColor: color.secondaryContainer,
        activeColor: color.surface,
        tabBorderRadius: 30,
        tabBackgroundColor: color.primary,
        curve: Curves.easeOutExpo,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({super.key, required this.toScreen, required this.toScreenIcon, required this.toScreenTitle});
  final String toScreen;
  final Icon toScreenIcon;
  final String toScreenTitle;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      children: [
        ListTile(
            leading: toScreenIcon,
            title: Text(toScreenTitle),
            onTap: () {
              Get.back();
              Get.toNamed(toScreen);
            }),
        Divider(
          color: color.primary,
          thickness: 0.5,
        ),
      ],
    );
  }
}

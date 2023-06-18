import 'package:flutter/material.dart';

class MySnackbar {
  show(BuildContext context, String message, Color colour) {
    final color = Theme.of(context).colorScheme;
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: color.primary, fontWeight: FontWeight.bold),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: colour,
    ));
  }
}

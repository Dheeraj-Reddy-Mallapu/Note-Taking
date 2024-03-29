import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

mySnackBar(BuildContext context, String title, String message, ContentType contentType) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: AwesomeSnackbarContent(title: title, message: message, contentType: contentType),
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
  ));
}

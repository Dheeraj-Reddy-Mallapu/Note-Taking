import 'package:dynamic_color/dynamic_color.dart';
import 'package:note_taking_firebase/custom_color.g.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_firebase/firebase_options.dart';
import 'package:note_taking_firebase/screens/guide_screen.dart';
import 'package:note_taking_firebase/screens/new_note.dart';
import 'package:note_taking_firebase/screens/recycle_bin.dart';
import 'package:note_taking_firebase/services/google_signin.dart';
import 'package:note_taking_firebase/widget_tree.dart';
import 'package:provider/provider.dart';

import 'color_schemes.g.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    //webRecaptchaSiteKey: recaptchaV3SiteKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: ((ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightScheme;
        ColorScheme darkScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightScheme = lightDynamic.harmonized();
          lightCustomColors = lightCustomColors.harmonized(lightScheme);

          darkScheme = darkDynamic.harmonized();
          darkCustomColors = darkCustomColors.harmonized(darkScheme);
        } else {
          // Otherwise, use fallback schemes.
          lightScheme = lightColorScheme;
          darkScheme = darkColorScheme;
        }

        return ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: MaterialApp(
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightScheme,
              extensions: [lightCustomColors],
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkScheme,
              extensions: [darkCustomColors],
            ),
            home: const WidgetTree(),
            routes: {
              'guide': (context) => const GuideScreen(),
              'recycleBin': (context) => const RecycleBin(),
              'newNote': (context) => const NewNote(),
            },
          ),
        );
      }),
    );
  }
}

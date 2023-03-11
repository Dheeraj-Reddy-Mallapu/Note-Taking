import 'package:dynamic_color/dynamic_color.dart';
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

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: ((ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: MaterialApp(
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightDynamic ?? _defaultLightColorScheme,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkDynamic ?? _defaultDarkColorScheme,
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

final _defaultLightColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
final _defaultDarkColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:note_taking_firebase/custom_color.g.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_firebase/firebase_options.dart';
import 'package:note_taking_firebase/provider/data_provider.dart';
import 'package:note_taking_firebase/screens/drawings/drawing_pad.dart';
import 'package:note_taking_firebase/screens/friends_list.dart';
import 'package:note_taking_firebase/screens/guide_screen.dart';
import 'package:note_taking_firebase/screens/notes/new_note.dart';
import 'package:note_taking_firebase/screens/notes/recycle_bin.dart';
import 'package:note_taking_firebase/services/google_signin.dart';
import 'package:note_taking_firebase/widget_tree.dart';
import 'package:provider/provider.dart';

import 'color_schemes.g.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    MobileAds.instance.initialize();
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider: kReleaseMode ? AndroidProvider.playIntegrity : AndroidProvider.debug,
    webProvider: ReCaptchaV3Provider(recaptchaV3SiteKey),
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

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
            ChangeNotifierProvider(create: (context) => DataProvider()),
          ],
          child: GetMaterialApp(
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
            getPages: [
              GetPage(name: '/Guide', page: () => const GuideScreen()),
              GetPage(name: '/RecycleBin', page: () => const RecycleBin()),
              GetPage(name: '/NewNote', page: () => const NewNote()),
              GetPage(name: '/DrawingPad', page: () => const DrawingPad()),
              GetPage(name: '/FriendsList', page: () => const FriendsList()),
              //GetPage(name: '/ShareScreen', page: () => const ShareScreen()),
            ],
          ),
        );
      }),
    );
  }
}

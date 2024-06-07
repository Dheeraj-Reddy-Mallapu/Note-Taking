import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_firebase/provider/data_provider.dart';
import 'package:note_taking_firebase/screens/home_screen.dart';
import 'package:note_taking_firebase/screens/welcome_screen.dart';
import 'package:note_taking_firebase/widgets/my_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:update_available/update_available.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    checkUpdate() async {
      final updateAvailability = await getUpdateAvailability();

      if (updateAvailability == const UpdateAvailable()) {
        mySnackBar(
            // ignore: use_build_context_synchronously
            context,
            'New Update Available',
            'Update now in play store for latest experience',
            ContentType.warning);
      }
    }

    if (!kIsWeb) {
      checkUpdate();
    }

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          dataProvider.startNotesStrean(FirebaseAuth.instance.currentUser!.uid);

          return const HomeScreen();
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Something Went Wrong!'),
          );
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}

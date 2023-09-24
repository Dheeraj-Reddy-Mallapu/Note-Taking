import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_taking_firebase/services/google_signin.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: const Text(
              'Note Taking App',
              style: TextStyle(
                fontSize: 32,
              ),
            ),
          ),
          InkWell(
              child: SizedBox(
                height: 300,
                width: 300,
                child: Image.asset('assets/notes.png'),
              ),
              onLongPress: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      actions: [
                        ElevatedButton(
                          child: const Text('SignIn Anonymously'),
                          onPressed: () {
                            FirebaseAuth.instance.signInAnonymously();
                            Get.back();
                          },
                        )
                      ],
                      title: const Text('Only for reviewers'),
                    ),
                  )),
          const SizedBox(height: 25),
          ElevatedButton.icon(
            label: const Text('SignIn'),
            icon: Image.asset('assets/google.png', height: 20),
            onPressed: () async {
              final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
              await provider.googleLogin();
            },
          ),
        ],
      ),
    );
  }
}

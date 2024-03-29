import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_taking_firebase/services/google_signin.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isPolicyAccepted = false;

  @override
  Widget build(BuildContext context) {
    privacyPoilicy() => Get.defaultDialog(
          onWillPop: () async => false,
          title: 'Privacy Policy',
          content: const SelectableText(
            '* We use your gmail and it\'s user id for account management and backup.\n'
            '* All the data (notes) created by you is stored in Firebase and is encoded (not encrypted) and is encrypted in transit.\n'
            '* To delete all your data from us, you can mail us at dheerajreddy963@gmail.com. We will process your request.'
            '* For more info visit: https://github.com/Dheeraj-Reddy-Mallapu/Privacy-Policies/blob/main/privacy-policy.md',
            textAlign: TextAlign.justify,
          ),
          confirm: ElevatedButton(
            onPressed: () => setState(() {
              isPolicyAccepted = true;
              Get.back();
            }),
            child: const Text('Accept'),
          ),
          cancel: TextButton(
            onPressed: () => Get.back(),
            child: const Text('Quit'),
          ),
        );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => isPolicyAccepted ? null : privacyPoilicy());

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
              if (isPolicyAccepted) {
                await provider.googleLogin();
              } else {
                await privacyPoilicy();
                if (isPolicyAccepted) {
                  await provider.googleLogin();
                }
              }
            },
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: privacyPoilicy,
        child: const Text('Privacy Policy'),
      ),
    );
  }
}

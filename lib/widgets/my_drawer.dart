import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_taking_firebase/services/firestore.dart';
import 'package:note_taking_firebase/services/google_signin.dart';
import 'package:note_taking_firebase/widgets/my_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String displayName = '';
  String photoURL = '';
  String displayEmail = '';

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    final signinProvider = Provider.of<GoogleSignInProvider>(context);

    if (user.isAnonymous) {
      displayName = 'Hello User!';
    } else {
      displayName = user.displayName!;
      photoURL = user.photoURL!;
      displayEmail = user.email!;
    }

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(displayName, style: TextStyle(color: color.surface)),
            accountEmail: Text(displayEmail, style: TextStyle(color: color.surface)),
            currentAccountPicture: CircleAvatar(backgroundImage: NetworkImage(photoURL)),
          ),
          Center(
            child: TextButton(
                onPressed: () {
                  Get.defaultDialog(
                      title: 'QR Code',
                      titleStyle: TextStyle(color: color.primary),
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height * .4,
                        width: MediaQuery.of(context).size.width * .8,
                        child: Column(
                          children: [
                            GestureDetector(
                              child: QrImageView(data: user.uid),
                              onTap: () => Share.share(user.uid),
                            ),
                            Center(
                              child: Text(
                                'Scan or tap the QR code to share',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, color: color.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [ElevatedButton(onPressed: () => Get.back(), child: const Text('Done'))]);
                },
                child: const Text('My Unique code')),
          ),
          Divider(
            color: color.primary,
            thickness: 0.5,
          ),
          const MyListTile(
            toScreen: '/FriendsList',
            toScreenIcon: Icon(Icons.people_rounded),
            toScreenTitle: 'Friends',
          ),
          const MyListTile(
            toScreen: '/RecycleBin',
            toScreenIcon: Icon(Icons.recycling_rounded),
            toScreenTitle: 'Recycle Bin',
          ),
          const MyListTile(
            toScreen: '/Guide',
            toScreenIcon: Icon(Icons.help_outline_rounded),
            toScreenTitle: 'Guide',
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('About'),
            onTap: () {
              Get.back();
              showAboutDialog(
                context: context,
                applicationName: 'Note Taking',
                applicationIcon: Image.asset('assets/notes.png', height: 40),
                children: [
                  const ListTile(
                    title: Text('Open Source Project'),
                  ),
                  const ListTile(
                    title: SelectableText('https://github.com/Dheeraj-Reddy-Mallapu'),
                  ),
                ],
              );
            },
          ),
          Divider(
            color: color.primary,
            thickness: 0.5,
          ),
          ElevatedButton(
            onPressed: () async => await signinProvider.googleLogout(),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

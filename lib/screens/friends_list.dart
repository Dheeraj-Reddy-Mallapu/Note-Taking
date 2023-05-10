import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_taking_firebase/custom_color.g.dart';
import 'package:note_taking_firebase/services/database.dart';
import 'package:share_plus/share_plus.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    final customColor = Theme.of(context).extension<CustomColors>()!;
    List<Color> colours = [
      color.secondaryContainer,
      customColor.greenishblueContainer!,
      customColor.yellowishgreenContainer!,
      customColor.yellowishbrownContainer!,
      customColor.pinkishredContainer!,
      customColor.blueContainer!,
      customColor.purpleContainer!,
    ];
    List<Color> primaryColours = [
      color.primary,
      customColor.greenishblue!,
      customColor.yellowishgreen!,
      customColor.yellowishbrown!,
      customColor.pinkishred!,
      customColor.blue!,
      customColor.purple!,
    ];

    final colourIndex = Random().nextInt(colours.length);

    final db = FireStore();

    final frndIdC = TextEditingController();
    final frndNameC = TextEditingController();
    final editNameC = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Get.defaultDialog(
                    title: 'Add a friend',
                    content: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: frndIdC,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                                labelText: 'Friend\'s Unique Id*'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: frndNameC,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                                labelText: 'Choose a nick name'),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (frndIdC.text.length == 28) {
                                db.addFriend(frndName: frndNameC.text, frndUid: frndIdC.text);
                                Get.back();
                              } else {
                                Get.snackbar(
                                  'Oops!',
                                  'Please enter 28 digit code',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            },
                            child: const Text('Add')),
                      ],
                    ));
              },
              child: const Text('Add a new friend')),
          Expanded(
            child: StreamBuilder<List>(
                stream: db.getFrndsList(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    final friendsData = snapshot.data!;
                    return ListView.builder(
                      itemCount: friendsData.length,
                      itemBuilder: (context, index) {
                        final data = friendsData[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3,
                                  color: primaryColours[colourIndex],
                                  offset: const Offset(0, 2),
                                )
                              ],
                              border: Border.all(
                                width: 0.5,
                                color: primaryColours[colourIndex],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              color: colours[colourIndex].withOpacity(0.9),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text('Name: '),
                                    Text(data['frndName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              editNameC.text = data['frndName'];
                                              Get.defaultDialog(
                                                  title: 'Edit name',
                                                  content: TextField(controller: editNameC),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text('Cancel')),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          db.updateFrndName(
                                                              frndName: editNameC.text, frndUid: data['frndUid']);
                                                          Get.back();
                                                        },
                                                        child: const Text('Save'))
                                                  ]);
                                            },
                                            icon: const Icon(Icons.edit)),
                                        IconButton(
                                          onPressed: () {
                                            Get.defaultDialog(
                                                title: 'Remove',
                                                content: Text("Do you want to remove '${data['frndName']}'"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: const Text('Cancel')),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        db.removeFrnd(frndUid: data['frndUid']);
                                                        Get.back();
                                                      },
                                                      child: const Text('Remove'))
                                                ]);
                                          },
                                          icon: Icon(Icons.delete, color: color.error),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('ID: '),
                                    Text(data['frndUid']),
                                    TextButton(
                                        onPressed: () {
                                          // Clipboard.setData(ClipboardData(text: data['frndUid']));
                                          // Get.snackbar(
                                          //   'Friend ID copied to clipboard',
                                          //   data['frndUid'],
                                          //   snackPosition: SnackPosition.BOTTOM,
                                          // );
                                          Share.share(data['frndUid']);
                                        },
                                        child: const Icon(Icons.share)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          )
        ],
      ),
    );
  }
}

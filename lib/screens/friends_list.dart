import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_taking_firebase/screens/qr_scanner.dart';
import 'package:note_taking_firebase/services/firestore.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    final dB = FireStore();

    final frndIdC = TextEditingController();
    final frndNameC = TextEditingController();
    final editNameC = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        centerTitle: true,
      ),
      body: StreamBuilder<List>(
        stream: dB.getFrndsList(),
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
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                  child: Card(
                    child: ListTile(
                      title: Text(data['frndName'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
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
                                            dB.updateFrndName(frndName: editNameC.text, frndUid: data['frndUid']);
                                            Get.back();
                                          },
                                          child: const Text('Save'))
                                    ],
                                  );
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
                                          dB.removeFrnd(frndUid: data['frndUid']);
                                          Get.back();
                                        },
                                        child: const Text('Remove'))
                                  ],
                                );
                              },
                              icon: Icon(Icons.delete, color: color.error),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          bool shouldPop = false;
          Get.defaultDialog(
            onWillPop: () async {
              return shouldPop;
            },
            title: 'Add a friend',
            content: Column(
              children: [
                if (!kIsWeb)
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.to(() => QRScan(frndIdC: frndIdC));
                    },
                    icon: const Icon(Icons.qr_code),
                    label: const Text('Scan QR'),
                  ),
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
                        labelText: 'Enter a nickname'),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  shouldPop = true;
                  Get.back();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (frndIdC.text.length == 28) {
                    final snapshot = await db.collection(frndIdC.text).get();
                    if (snapshot.size != 0) {
                      dB.addFriend(frndName: frndNameC.text, frndUid: frndIdC.text);
                      shouldPop = true;
                      Get.back();
                    } else {
                      Get.snackbar(
                        'Oops!',
                        'Please check the code again',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  } else {
                    Get.snackbar(
                      'Oops!',
                      'Please enter 28 digit code',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
        child: const Text('Add a friend'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

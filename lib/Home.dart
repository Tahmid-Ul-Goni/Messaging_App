import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:untitled12/chat_room.dart';

import 'Route.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();

  Future signOut() async {
    showDialog<void>(
      context: context,

      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('You want to Singout?'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextButton(
                onPressed: () async {
                  _auth.signOut();
                  Get.toNamed(Singin);
                },
                child: Text('Yes', style: TextStyle(color: Colors.red)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void onSearch() async {
    FirebaseFirestore _firebase = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    try {
      var result =
          await _firebase
              .collection('users')
              .where("email", isEqualTo: _searchController.text.trim())
              .get();

      if (result.docs.isNotEmpty) {
        setState(() {
          userMap = result.docs.first.data();
          isLoading = false;
        });
        print(userMap);
      } else {
        Fluttertoast.showToast(msg: 'User not found');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      setState(() {
        isLoading = false;
      });
    }
  }

  String ChatRoomId(String user1, String user2) {
    if (user1.isEmpty || user2.isEmpty) return '';
    return (user1.toLowerCase().compareTo(user2.toLowerCase()) > 0)
        ? "$user1$user2"
        : "$user2$user1";
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;
    final currentUserName = currentUser?.displayName ?? "Unknown";
    final currentUserEmail = currentUser?.email ?? "unknown@example.com";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Home", style: TextStyle(fontSize: 15)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search",
                suffixIcon: IconButton(
                  onPressed: () {
                    onSearch();
                    _searchController.clear();
                  },
                  icon: const Icon(Icons.search_outlined),
                ),
              ),
            ),
            const SizedBox(height: 20),
            userMap != null
                ? ListTile(
                  onTap: () {
                    String roomId = ChatRoomId(
                      currentUserName,
                      userMap!['name'],
                    );
                    Get.toNamed(
                      'ChatRoom',
                      arguments: ChatRoom(
                        userEmail: currentUserEmail,
                        userName: currentUserName,

                        userMap: userMap!,
                      ),
                    );
                  },
                  leading: const CircleAvatar(
                    child: Center(child: Icon(Icons.person_outline, size: 20)),
                  ),
                  title: Text(
                    userMap!['name'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(userMap!['email']),
                  trailing: const Icon(Icons.chat_bubble_outline, size: 20),
                )
                : Container(),
            const SizedBox(height: 30),
            const Divider(height: 2, color: Colors.black),
            const SizedBox(height: 10),
            const Align(alignment: Alignment.topLeft, child: Text("Recent")),
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection('recent')
                        .doc('0000')
                        .collection(currentUserEmail)
                        .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error"));
                  } else if (snapshot.hasData &&
                      snapshot.data.docs.isNotEmpty) {
                    var data = snapshot.data.docs;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        var indexData = data[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 10,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 223, 210, 231),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: ListTile(
                              onTap: () {
                                String roomId = ChatRoomId(
                                  currentUserName,
                                  indexData['name'],
                                );
                                Get.toNamed(
                                  '/ChatRoom',
                                  arguments: ChatRoom(
                                    userEmail: currentUserEmail,
                                    userName: currentUserName,
                                    userMap: indexData.data(),
                                  ),
                                );
                              },
                              leading: const CircleAvatar(
                                child: Center(
                                  child: Icon(
                                    Icons.person_outlined,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              title: Text(indexData['name']),
                              subtitle: Text(indexData['email']),
                              trailing: const Icon(
                                Icons.chat_outlined,
                                size: 17,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text("No recent chats"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

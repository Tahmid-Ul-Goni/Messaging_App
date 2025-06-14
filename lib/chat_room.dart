import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ChatRoom extends StatefulWidget {
  final String userEmail;
  final String userName;
  final Map<String, dynamic> userMap;

  ChatRoom({
    required this.userEmail,
    required this.userName,
    required this.userMap,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? imageFile;
  late String chatRoomId;

  @override
  void initState() {
    super.initState();
    chatRoomId = generateChatRoomId(widget.userEmail, widget.userMap['email']);
  }

  String generateChatRoomId(String email1, String email2) {
    email1 = email1.trim().toLowerCase();
    email2 = email2.trim().toLowerCase();
    return (email1.compareTo(email2) > 0) ? "$email1$email2" : "$email2$email1";
  }

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? xFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 30);
    if (xFile != null) {
      setState(() {
        imageFile = File(xFile.path);
      });
      uploadImage();
    } else {
      Fluttertoast.showToast(msg: "No image selected");
    }
  }

  Future uploadImage() async {
    if (imageFile == null) {
      Fluttertoast.showToast(msg: "No image selected");
      return;
    }

    int status = 1;
    String fileName = Uuid().v1();

    // First create firestore document with empty message
    await _firestore.collection('ChatRoom').doc(chatRoomId).collection("chats").doc(fileName).set({
      "sendby": _auth.currentUser!.email,
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    try {
      var ref = FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");
      UploadTask uploadTask = ref.putFile(imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      await _firestore.collection('ChatRoom').doc(chatRoomId).collection('chats').doc(fileName).update({
        "message": imageUrl,
      });

    } catch (e) {
      await _firestore.collection('ChatRoom').doc(chatRoomId).collection('chats').doc(fileName).delete();
      status = 0;
    }

    if (status == 0) {
      Fluttertoast.showToast(msg: "Image upload failed");
    }
  }

  void onSendMessage() async {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.email,
        "message": _messageController.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _messageController.clear();

      await _firestore.collection("ChatRoom").doc(chatRoomId).collection("chats").add(messages);
    } else {
      Fluttertoast.showToast(msg: "Please type a message");
    }
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    bool isMe = map['sendby'] == _auth.currentUser!.email;

    return Container(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: map['type'] == "text"
          ? Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(map['message']),
      )
          : Container(
        height: 200,
        width: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            map['message'],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.broken_image, size: 50, color: Colors.red);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.blue)),
        title: Text(widget.userMap['name'], style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 15,
          right: 15,
        ),
        child: Column(children: [
          Container(
            height: size.height / 1.30,
            width: size.width,
            child: StreamBuilder(
              stream: _firestore
                  .collection("ChatRoom")
                  .doc(chatRoomId)
                  .collection('chats')
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        return Align(alignment: Alignment.bottomCenter, child: messages(size, map, context));
                      });
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: 1,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 236, 235, 239),
                        suffixIcon: IconButton(
                          onPressed: () => getImage(),
                          icon: const Icon(Icons.photo, color: Colors.blue),
                        ),
                        hintText: "Send Message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                        )),
                  )),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: onSendMessage,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
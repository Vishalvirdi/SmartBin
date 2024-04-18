import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smartbin/services/database.dart';
import 'package:smartbin/utils/constants.dart';
import 'package:smartbin/widgets/messageTile.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final String? token;
  final double height;
  final String id;
  final String phone;
  ChatScreen(
      {super.key,
      required this.id,
      required this.phone,
      required this.height,
      this.token});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  bool _isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    var ref = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      if (imageUrl != "") {
        Map<String, dynamic> chatMessageMap = {
          "message": imageUrl,
          "sender": widget.phone,
          "time": FieldValue.serverTimestamp(),
          "type": "img",
        };

        uploadMessage(widget.id, chatMessageMap);
      }
    }
  }

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    getChats(widget.id).then((val) {
      setState(() {
        chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "SmartBin",
          style: TextStyle(
              fontSize: 25,
              shadows: [Shadow(color: gray, blurRadius: 10)],
              fontFamily: 'Times new roman'),
        ),
      ),
      backgroundColor: bgColor,
      body: Stack(
        children: <Widget>[
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              width: width(context),
              child: Row(
                children: [
                  Flexible(
                      child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: TextFormField(
                        controller: messageController,
                        cursorColor: primaryColor,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                              onPressed: () {
                                getImage();
                              },
                              icon: Icon(Icons.image)),
                          border: InputBorder.none,
                          hintText: "Complain",
                          hintStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  )),
                  Card(
                    color: primaryColor,
                    elevation: 20,
                    shadowColor: black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Container(
                height: widget.height,
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    final DateTime dateTime = fromJson(
                        snapshot.data.docs[index]['time'] != null
                            ? snapshot.data.docs[index]['time']
                            : Timestamp.now());

                    final String date = DateFormat.yMMMd().format(dateTime);

                    return widget.token != "admin"
                        ? date == DateFormat.yMMMd().format(DateTime.now())
                            ? MessageTile(
                                message: snapshot.data.docs[index]['message'],
                                sender: snapshot.data.docs[index]['sender'],
                                type: snapshot.data.docs[index]['type'],
                                time: dateTime,
                                sentByMe: widget.phone ==
                                    snapshot.data.docs[index]['sender'])
                            : Container()
                        : MessageTile(
                            message: snapshot.data.docs[index]['message'],
                            sender: snapshot.data.docs[index]['sender'],
                            type: snapshot.data.docs[index]['type'],
                            time: dateTime,
                            sentByMe: widget.phone ==
                                snapshot.data.docs[index]['sender']);
                  },
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                color: primaryColor,
              ));
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.phone,
        "time": FieldValue.serverTimestamp(),
        "type": "text",
      };

      uploadMessage(widget.id, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}

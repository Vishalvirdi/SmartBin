import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartbin/services/database.dart';

import 'package:smartbin/utils/constants.dart';
import 'package:smartbin/widgets/groupTile.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    // gettingUserData();
    getUserGroups();
  }

  getUserGroups() async {
    final data = await getGroups();
    setState(() {
      groups = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              popback(context);
            },
            icon: Icon(Icons.arrow_back_ios_rounded)),
        backgroundColor: Colors.transparent,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Message",
          // style: text18w500(white2),
        ),
      ),
      backgroundColor: primaryColor,
      body: groupList(),
    );
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data.docs != null) {
            if (snapshot.data.docs.length != 0) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data.docs.length - index - 1;

                  final DateTime dateTime = snapshot.data.docs[reverseIndex]
                              ['recentMessageTime'] !=
                          null
                      ? snapshot.data.docs[reverseIndex]['recentMessageTime']
                          .toDate()
                      : Timestamp.now().toDate();

                  final String recentTime =
                      DateFormat.Hm().format(dateTime).toString();

                  return GroupTile(
                      groupId: snapshot.data.docs[reverseIndex].id,
                      userName: "admin",
                      recentMessage: snapshot.data.docs[reverseIndex]
                          ['recentMessage'],
                      sender: snapshot.data.docs[reverseIndex]
                          ['recentMessageSender'],
                      recentTime: recentTime);
                  // return Container();
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Center(
      child: Container(
        decoration: BoxDecoration(color: black, boxShadow: [
          BoxShadow(color: primaryColor, blurRadius: 2, spreadRadius: 2)
        ]),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Text(
          "No complaints yet!",
          // style: text18w500(white2),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

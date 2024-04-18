import 'package:flutter/material.dart';
import 'package:smartbin/utils/constants.dart';
import 'package:smartbin/view/chatscreen.dart';

class GroupTile extends StatefulWidget {
  final String? groupId;
  final String? userName;
  final String? recentMessage;
  final String? recentTime;
  final String? sender;
  const GroupTile(
      {Key? key,
      this.groupId,
      this.userName,
      this.recentTime,
      this.sender,
      this.recentMessage})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatScreen(
                token: "admin",
                id: widget.groupId.toString(),
                phone: "admin",
                height: height(context) - 140));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.person_outline_outlined),
            ),
            title: Text(
              widget.groupId.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // subtitle: Text(
            //   widget.sender == "admin"
            //       ? "You: " + widget.recentMessage.toString()
            //       : widget.sender.toString() +
            //           ":" +
            //           " " +
            //           widget.recentMessage.toString(),
            //   // style: text12w400(grey, overflow: TextOverflow.ellipsis),
            // ),
            trailing: Text(
              widget.recentTime.toString(),
              // style: text10w400(
              //   black,
              // ),
            ),
          ),
        ),
      ),
    );
  }
}

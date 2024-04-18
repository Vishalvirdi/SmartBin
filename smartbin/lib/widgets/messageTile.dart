import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:smartbin/utils/constants.dart';
import 'package:smartbin/widgets/showImageScreen.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final String type;
  final DateTime time;
  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe,
      required this.time,
      required this.type})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0 : 24,
          right: widget.sentByMe ? 24 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30, bottom: 2)
            : const EdgeInsets.only(right: 30, bottom: 2),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurStyle: BlurStyle.solid,
                  spreadRadius: 1,
                  blurRadius: 1,
                  color: white)
            ],
            borderRadius: widget.sentByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            color: widget.sentByMe ? primaryColor : white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sentByMe
                      ? "You".toUpperCase()
                      : widget.sender.toUpperCase(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: widget.sentByMe ? white : black,
                      letterSpacing: -0.5),
                ),
                const SizedBox(
                  height: 8,
                ),
                widget.type == "text"
                    ? Text(widget.message,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16,
                            color: widget.sentByMe ? white : black))
                    : InkWell(
                        onTap: () {
                          nextScreen(
                              context,
                              ShowImageScreen(
                                image: widget.message,
                                sender: widget.sentByMe ? "You" : widget.sender,
                                time: DateFormat.Hm()
                                    .format(widget.time)
                                    .toString(),
                              ));
                        },
                        child: Hero(
                          tag: widget.message,
                          child: Image.network(
                            widget.message,
                            width: width(context) / 3.5,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
              ],
            ),
            verticalSpace(4),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(DateFormat.Hm().format(widget.time).toString(),
                  style: TextStyle(
                      fontSize: 8, color: widget.sentByMe ? white : black)),
            ),
          ],
        ),
      ),
    );
  }
}

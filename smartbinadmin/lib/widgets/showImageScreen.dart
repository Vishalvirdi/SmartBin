import 'package:flutter/material.dart';
import 'package:smartbin/utils/constants.dart';

class ShowImageScreen extends StatefulWidget {
  final String image;
  final String sender;
  final String time;
  const ShowImageScreen(
      {super.key,
      required this.image,
      required this.sender,
      required this.time});

  @override
  State<ShowImageScreen> createState() => _ShowImageScreenState();
}

class _ShowImageScreenState extends State<ShowImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.sender,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500, color: white),
            ),
            Text(
              widget.time,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w400, color: white),
            )
          ],
        ),
        elevation: 0,
        backgroundColor: black.withOpacity(.5),
      ),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Container(
          color: black.withOpacity(.5),
          height: height(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Hero(
                  tag: widget.image,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

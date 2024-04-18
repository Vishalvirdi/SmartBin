import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:smartbin/utils/constants.dart';
import 'package:smartbin/view/mapscreen.dart';

class DustbinsPage extends StatefulWidget {
  final int length;
  final String token;
  const DustbinsPage({super.key, required this.length, required this.token});

  @override
  State<DustbinsPage> createState() => _DustbinsPageState();
}

class _DustbinsPageState extends State<DustbinsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.token == "red" ? Colors.red : primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Dustbins",
          style: TextStyle(
              fontSize: 25,
              shadows: [Shadow(color: gray, blurRadius: 10)],
              fontFamily: 'Times new roman'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: widget.length,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          nextScreen(context, MapScreen());
                        },
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          tileColor:
                              widget.token == "red" ? Colors.red : primaryColor,
                          leading: Icon(
                            Icons.map_sharp,
                            color: white,
                          ),
                          title: Text(
                            "IIITUNA, Himachal Pradesh",
                            style: TextStyle(color: white),
                          ),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.share,
                                color: white,
                              )),
                        ),
                      ),
                    ))
          ],
        ),
      ),
    );
  }
}

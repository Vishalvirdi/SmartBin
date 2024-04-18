import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const primaryColor = Colors.green;
// const primaryColor = Color.fromARGB(233, 69, 152, 221);
const white = Colors.white;
const black = Colors.black;
const gray = Colors.grey;
const bgColor = Color.fromARGB(255, 194, 193, 193);

nextScreen(BuildContext context, Widget screen) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => screen));
}

popback(BuildContext context) {
  return Navigator.pop(context);
}

removeScreen(BuildContext context, Widget screen) {
  return Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => screen), (route) => false);
}

width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

verticalSpace(double height) {
  return SizedBox(height: height);
}

DateTime fromJson(Timestamp timestamp) {
  return timestamp.toDate();
}

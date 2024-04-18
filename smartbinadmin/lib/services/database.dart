import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final CollectionReference groupCollection =
    FirebaseFirestore.instance.collection("groups");
final CollectionReference userCollection =
    FirebaseFirestore.instance.collection("users");

Future<void> verifyPhoneNumber(
    String phoneNumber, BuildContext context, Function setData) async {
  PhoneVerificationCompleted verificationCompleted =
      (PhoneAuthCredential phoneAuthCredential) async {
    // openSnackbar(context, "Verification Completed", primaryColor);
  };
  PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException exception) {
    // openSnackbar(context, exception.toString(), primaryColor);
  };
  PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationID) {
    // openSnackbar(context, "Time out", primaryColor);
  };
  try {
    await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: Duration(seconds: 60),
        phoneNumber: "+91 ${phoneNumber}",
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: (String? verificationId, int? resendToken) {
          // openSnackbar(
          // context, "Verification Code has been sent.", primaryColor);
          setData(verificationId);
        },
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  } catch (e) {
    // openSnackbar(context, e.toString(), primaryColor);
  }
}

Future signInwithPhoneNumber(String phone, String verificationId,
    String smsCode, BuildContext context) async {
  try {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (userCredential != null) {
      final user = userCredential.user;

      // bool decision = await DatabaseService(uid: user!.uid).checkUserExists();
      // await HelperFunctions.saveUserUidSF(user.uid);
      // if (decision) {
      //   return true;
      // } else {
      //   await DatabaseService(uid: user.uid)
      //       .savingUserData("", "", phone.toString(), profileIcon);
      // }

      return true;
    }
  } catch (e) {
    if (e == "Time out") {
    } else {}
  }
}

Future createUser(User user) async {
  final data =
      await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
  if (!data.exists) {
    await userCollection
        .doc(user.uid)
        .set({"groupId": "", "phone": user.phoneNumber});
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members

    await userCollection.doc(user.uid).update({
      "groupId": groupDocumentReference.id,
    });
  }
}

getChats(String groupId) async {
  return groupCollection
      .doc(groupId)
      .collection("messages")
      .orderBy("time")
      .snapshots();
}

uploadMessage(String groupId, Map<String, dynamic> chatMessageData) async {
  await groupCollection
      .doc(groupId)
      .collection("messages")
      .add(chatMessageData);
  await groupCollection.doc(groupId).update({
    "recentMessage": chatMessageData['message'],
    "recentMessageSender": chatMessageData['sender'],
    "recentMessageTime": chatMessageData['time'],
  });
}

getGroups() async {
  return await groupCollection.orderBy("recentMessageTime").snapshots();
}

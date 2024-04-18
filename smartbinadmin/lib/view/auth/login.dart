import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:smartbin/services/database.dart';
import 'package:smartbin/services/helper.dart';
import 'package:smartbin/view/homepage.dart';
import 'dart:async';
import '../../utils/constants.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  login() {
    signInwithPhoneNumber(
            phoneController.text, verificationIdFinal, smsCode, context)
        .then((value) async {
      if (value == true) {
        final user = await FirebaseAuth.instance.currentUser;

        // await HelperFunctions.saveUserLoggedInStatus(true);
        // await DatabaseService(uid: user!.uid)
        //     .getUserDataField(context, num: 3);
        createUser(user!);
        await HelperFunctions.saveUserLoggedInStatus(true);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  TextEditingController phoneController = TextEditingController();
  int start = 30;
  bool wait = false;
  String buttonName = "Send OTP";
  String verificationIdFinal = "";
  String smsCode = "";
  final TextEditingController _pinPutController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    decoration: BoxDecoration(
      border: Border.all(color: black),
      borderRadius: BorderRadius.circular(10),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: SingleChildScrollView(
        child: Container(
          height: height(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/images/img.gif"),
                    const Text(
                      "Phone Number",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: black,
                          fontFamily: 'Times new roman'),
                    ),
                    verticalSpace(7),
                    Form(
                      key: key,
                      child: TextFormField(
                        maxLength: 10,
                        controller: phoneController,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: black,
                            fontFamily: 'Times new roman'),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 27, vertical: 22),
                          hintText: "Phone Number",
                          filled: true,
                          hintStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                          fillColor: white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 2),
                            child: Text(
                              " (+91) ",
                              style: TextStyle(),
                            ),
                          ),
                          suffixIcon: InkWell(
                            onTap: wait
                                ? null
                                : () async {
                                    setState(() {
                                      start = 30;
                                      wait = true;
                                      buttonName = "Resend";
                                    });
                                    await verifyPhoneNumber(
                                        phoneController.text.toString(),
                                        context,
                                        setData);
                                  },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 15),
                              child: Text(
                                buttonName,
                                style: TextStyle(
                                  color: wait ? gray : black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    verticalSpace(27),
                    const Text(
                      "OTP",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: black,
                          fontFamily: 'Times new roman'),
                    ),
                    verticalSpace(7),
                    Center(
                      child: Pinput(
                        onCompleted: (value) {
                          setState(() {
                            smsCode = value;
                          });
                        },
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                        controller: _pinPutController,
                        pinAnimationType: PinAnimationType.fade,
                      ),
                    ),
                    verticalSpace(25),
                    Center(
                      child: RichText(
                          text: TextSpan(
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: black,
                            fontFamily: 'Times new roman'),
                        children: [
                          const TextSpan(
                            text: "Send OTP again in ",
                          ),
                          TextSpan(
                            text: "00:$start",
                          ),
                          const TextSpan(
                            text: " sec ",
                          ),
                        ],
                      )),
                    ),
                    verticalSpace(47),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(68)),
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 55)),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: white,
                            fontFamily: 'Times new roman'),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer _timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTimer();
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smartbin/services/helper.dart';
import 'package:smartbin/utils/constants.dart';
import 'package:smartbin/view/auth/login.dart';
import 'package:smartbin/view/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isSignedIn = false;
  getMainScreen() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
    Timer(const Duration(seconds: 4), () async {
      _isSignedIn
          ? removeScreen(context, const HomePage())
          : removeScreen(context, const LogIn());
    });
  }

  @override
  void initState() {
    getMainScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/bin.gif",
            color: primaryColor,
          ),
          const Text(
            "SmartBin",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                fontFamily: 'Times new roman',
                shadows: [Shadow(color: Colors.grey, blurRadius: 4)],
                color: primaryColor),
          )
        ],
      ),
    );
  }
}

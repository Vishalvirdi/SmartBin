import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smartbin/services/helper.dart';
import 'package:smartbin/utils/constants.dart';
import 'package:smartbin/view/auth/login.dart';
import 'package:smartbin/view/chats.dart';
import 'package:smartbin/view/dustbinpage.dart';
import 'package:smartbin/view/mapscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final databaseRef = FirebaseDatabase.instance.ref("mydata").child("value");
  final ref = FirebaseDatabase.instance.ref().child("number");
  String groupId = "";
  String phone = "";

  giveId() async {
    if (user!.uid != null) {
      final userCollection = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();
      final data = userCollection.data() as Map<String, dynamic>;

      groupId = data['groupId'];
      phone = data['phone'];
      setState(() {});
    }
  }

  Future<void> showNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        wakeUpScreen: true,
        id: 0,
        customSound: 'assets/images/music.mp3',
        channelKey: 'basic_channel',
        title: 'Alert',
        body: 'Dustbin has filled',
      ),
    );
  }

  bool notify = true;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState

    giveId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: primaryColor),
                accountName: Text(
                  "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentAccountPicture: Icon(
                  Icons.person_pin,
                  size: 80,
                )),
            ListTile(
              leading: Icon(
                Icons.person_pin_circle_sharp,
                color: primaryColor,
              ),
              title: const Text('IIITUNA, Himachal Pradesh'),
            ),
            ListTile(
              leading: Icon(
                Icons.phone,
                color: primaryColor,
              ),
              title: Text(phone),
            ),
            ListTile(
              leading: Icon(
                Icons.shield_rounded,
                color: primaryColor,
              ),
              title: Text(user!.uid),
            ),
            AboutListTile(
              // <-- SEE HERE
              icon: Icon(
                Icons.info,
                color: primaryColor,
              ),
              child: Text('About Us'),
              applicationIcon: Icon(
                Icons.location_city_sharp,
                color: primaryColor,
              ),
              applicationName: 'Smart Waste Management',
              applicationVersion: '1.0.25',
              applicationLegalese: '© 2023 IIITUNA',
              aboutBoxChildren: [
                ///Content goes here...
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            nextScreen(context, MessagePage());
          },
          child: const Icon(
            Icons.message_outlined,
            size: 30,
            shadows: [Shadow(color: gray, blurRadius: 10)],
          )),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              _key.currentState!.openDrawer();
            },
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile.jpg"),
            ),
          ),
        ),
        title: const Text(
          "Dashboard",
          style: TextStyle(
              fontSize: 25,
              shadows: [Shadow(color: gray, blurRadius: 10)],
              fontFamily: 'Times new roman'),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await HelperFunctions.saveUserLoggedInStatus(false);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LogIn()),
                    (route) => false);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/images/banner.jpg",
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "SWMS",
                        style: TextStyle(
                            fontFamily: 'Times new roman',
                            color: black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "A admin panel to control the activies related to Waste management system",
                        style: TextStyle(
                            fontFamily: 'Times new roman',
                            color: black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Filled Dustbins",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Times New roman',
                                  ),
                                ),
                                verticalSpace(5),
                                Text(
                                  "10",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () {
                                      nextScreen(
                                          context,
                                          DustbinsPage(
                                            token: "red",
                                            length: 10,
                                          ));
                                    },
                                    child: Text("See Details"))
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Dustbins",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Times New roman',
                                  ),
                                ),
                                verticalSpace(5),
                                Text(
                                  "15",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      nextScreen(
                                          context,
                                          DustbinsPage(
                                            token: "green",
                                            length: 15,
                                          ));
                                    },
                                    child: Text("See Details"))
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.delete,
                              color: primaryColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(10),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: primaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Your Location",
                        style: TextStyle(
                            fontFamily: 'Times new roman',
                            color: black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: Text(
                      "IIIT UNA, Himachal Pradesh",
                      style: TextStyle(
                          fontFamily: 'Times new roman',
                          color: black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  StreamBuilder(
                    stream: ref.onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.snapshot.value != null) {
                          if (int.parse(
                                  snapshot.data!.snapshot.value.toString()) <=
                              3) {
                            notify ? showNotification() : null;
                            notify = false;
                          }
                        } else {
                          notify = true;
                        }
                      }
                      return snapshot.hasData
                          ? snapshot.data!.snapshot.value != null
                              ? int.parse(snapshot.data!.snapshot.value
                                          .toString()) <=
                                      3
                                  ? Card(
                                      color: Colors.red.shade400,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Dustbin is filled at IIIT UNA",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ))
                                  : Card(
                                      color: Colors.green.shade400,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Dustbin's level is ${int.parse(snapshot.data!.snapshot.value.toString()) / 16 * 100}%",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ))
                              : CircularProgressIndicator()
                          : CircularProgressIndicator();
                    },
                  ),
                  verticalSpace(20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MapScreen()));
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset("assets/images/map.jpg")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/test2.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:

import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/StarRatingModel.dart';
import 'Admin/test.dart';
import 'Authentication/FreezedUser.dart';
import 'Authentication/Notification.dart';
import 'Counters/Likeitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Models/GetLikeItemsModel.dart';
import 'Models/HEXCOLOR.dart';
import 'Models/allList.dart';
import 'PushNotifications/PushNotificationPage.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = FirebaseFirestore.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (c) => LikeItemCounter(),
        ),
        ChangeNotifierProvider(
          create: (c) => AddressChanger(),
        ),
        ChangeNotifierProvider(
          create: (c) => GetLikeItemsModel()..fetchItems(),
        ),
        ChangeNotifierProvider(
          create: (c) => StarRatingModel()..fetchItems(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        key: GlobalKey<ScaffoldState>(),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        theme: ThemeData(accentColor: bgColor, primaryColor: bgColor),
        routes: {
          '/message': (context) => UserNotification(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    displaySplash();
  }

  displaySplash() {
    //todo:Timerは何秒後に何をするか
    Timer(
      Duration(
        seconds: 3,
      ),
      () async {
        if (await EcommerceApp.auth.currentUser != null && mounted) {
          //todo:もしログインしていたら以下

          if (StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(EcommerceApp.sharedPreferences
                          .getString(EcommerceApp.userUID))
                      .snapshots(),
                  builder: (c, snap) {
                    return snap.data.data()["isFreeze"];
                  }) !=
              false) {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: MainPage(),
                inheritTheme: true,
                ctx: context,
                duration: Duration(
                  milliseconds: 3000,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: FreezeUser(),
                inheritTheme: true,
                ctx: context,
                duration: Duration(
                  milliseconds: 3000,
                ),
              ),
            );
          }
        } else {
          //todo:もしログインしていなかったら以下

          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: Login(),
              inheritTheme: true,
              ctx: context,
              duration: Duration(
                milliseconds: 500,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: FadeInImage.assetNetwork(
                  placeholder: "images/white.png",
                  image:
                      "https://firebasestorage.googleapis.com/v0/b/selling-pictures.appspot.com/o/isColor_Vertical.png?alt=media&token=d7895795-7d1d-4b5e-af38-0aebebfd7634",
                  height: 150,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  Future<QuerySnapshot> docList;
  var _sliderValue = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: (() {
        if (selectedIndex == 0) {
          return AppBar(
            leading: null,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.all(125.0),
              child: InkWell(
                child: Image.asset("images/isColor_Horizontal.png"),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => NeumoTest()));
                  EcommerceApp.sharedPreferences.setString(
                    "Registration Time",
                    "${(DateTime.now().millisecondsSinceEpoch / 1000).toInt()}",
                  );
                  print(EcommerceApp.sharedPreferences
                      .getString("Registration Time"));
                },
              ),
            ),
          );
        }
      })(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: bgColor,
        unselectedItemColor: Colors.grey,
        fixedColor: HexColor("E67928"),
        selectedLabelStyle:
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(color: Colors.black),
        currentIndex: selectedIndex,
        onTap: (int newIndex) {
          setState(() {
            selectedIndex = newIndex;
          });
        },
        items: navigationList
            .map((item) => BottomNavigationBarItem(
                  icon: item.icon,
                  label: item.title,
                ))
            .toList(),
      ),
      body: navigationList[selectedIndex].page,
    );
  }

  Widget searchWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 50,
        decoration: BoxDecoration(
          color: HexColor("ED9B5E"),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 8,
              ),
              child: Icon(
                Icons.search,
                color: Colors.blueGrey,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 8,
              ),
              child: TextField(
                onChanged: (val) {
                  startSearching(val);
                },
                decoration: InputDecoration.collapsed(hintText: "検索する"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future startSearching(String query) async {
    docList = FirebaseFirestore.instance
        .collection("items")
        .where("shortInfo", isGreaterThanOrEqualTo: query)
        .get();
  }
}

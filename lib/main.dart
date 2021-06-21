import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:selling_pictures_platform/Authentication/MyPage.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Models/bottom_navigation.dart';
import 'package:selling_pictures_platform/Store/like.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'Counters/Likeitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Models/HEXCOLOR.dart';
import 'Store/Search.dart';
import 'Store/storehome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = FirebaseFirestore.instance;
  runApp(MyApp());
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
          create: (c) => TotalAmount(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
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
        if (await EcommerceApp.auth.currentUser != null) {
          //todo:もしログインしていたら以下

          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: MainPage(),
              inheritTheme: true,
              ctx: context,
              duration: Duration(
                milliseconds: 1500,
              ),
            ),
          );
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
              //Image.asset("images/welcome.png"),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset(
                  "images/home_image.png",
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 3.0,
                        left: 7,
                      ),
                      child: Text(
                        "LEEWAY",
                        style: TextStyle(
                          color: Colors.red.withOpacity(0.4),
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Text(
                        "LEEWAY",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  ),
                ],
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
  List<BottomNavigationEntity> navigationList = [
    BottomNavigationEntity(
        title: "ホーム", icon: Icon(Icons.home_outlined), page: StoreHome()),
    BottomNavigationEntity(
        title: "いいね",
        icon: new Stack(
          children: [
            Icon(
              Icons.favorite_outline_outlined,
            ),
            Positioned(
              //top: 0.1,
              //bottom: 3,
              left: 10,
              child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1,
                    size: 15,
                    color: HexColor("E67928"),
                  ),
                  //todo: アイテムカウントの可視化
                  Positioned(
                    //top: 0.1,
                    //bottom: 0.1,
                    left: 5,
                    child: Consumer<LikeItemCounter>(
                      builder: (context, counter, _) {
                        Provider.of<LikeItemCounter>(context, listen: false)
                            .displayResult();
                        return Text(
                          (EcommerceApp.sharedPreferences
                                      .getStringList(EcommerceApp.userLikeList)
                                      .length -
                                  1)
                              .toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        page: LikePage()),
    // BottomNavigationEntity(
    //     title: "検索", icon: Icon(Icons.search), page: SearchProduct()),
    BottomNavigationEntity(
        title: "マイページ", icon: Icon(Icons.perm_identity), page: MyPage()),
  ];
  int selectedIndex = 0;
  Future<QuerySnapshot> docList;
  var _sliderValue = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (() {
        if (selectedIndex == 0) {
          return MyAppBar(
            title: Text(
              "LEEWAY",
              style: GoogleFonts.sortsMillGoudy(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.w100,
              ),
            ),
          );
        }
      })(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
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
          color: Colors.grey.withOpacity(0.5),
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
            Flexible(
                child: Padding(
              padding: EdgeInsets.only(
                left: 8,
              ),
              child: TextField(
                onChanged: (val) {
                  startSearching(val);
                },
                decoration: InputDecoration.collapsed(hintText: "検索する"),
              ),
            )),
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

import 'package:google_fonts/google_fonts.dart';
import 'package:selling_pictures_platform/Authentication/MyPage.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Store/cart.dart';
import 'package:selling_pictures_platform/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Store/like.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Route route = MaterialPageRoute(
            builder: (c) => MyPage(),
          );
          Navigator.pushReplacement(context, route);
        },
        icon: CircleAvatar(
          backgroundImage:
              NetworkImage(EcommerceApp.sharedPreferences.getString(
            EcommerceApp.userAvatarUrl,
          )),
        ),
      ),
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      title: Center(
        child: InkWell(
          onTap: () {
            Route route = MaterialPageRoute(
              builder: (c) => StoreHome(),
            );
            Navigator.pushReplacement(context, route);
          },
          child: Text(
            "LEEWAY",
            style: GoogleFonts.sortsMillGoudy(
              color: Colors.black,
              fontSize: 35,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.favorite_outline_outlined,
                color: Colors.black,
                size: 35,
              ),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => LikePage());
                Navigator.pushReplacement(context, route);
              },
            ),
            Positioned(
              child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1_outlined,
                    size: 20,
                    color: Colors.black,
                  ),
                  //todo: アイテムカウントの可視化
                  Positioned(
                    top: 3,
                    bottom: 4,
                    left: 6,
                    child: Consumer<LikeItemCounter>(
                      builder: (context, counter, _) {
                        return Text(
                          (EcommerceApp.sharedPreferences
                                      .getStringList(EcommerceApp.userLikeList)
                                      .length -
                                  1)
                              .toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
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
      ],
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

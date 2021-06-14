import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:selling_pictures_platform/Authentication/MyPage.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Config/config.dart';

import 'package:selling_pictures_platform/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Store/like.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';

import '../main.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  final Widget title;
  MyAppBar({this.bottom, this.title});
  final mainColor = HexColor("E67928");

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom,
      // leading: FirebaseAuth.instance.currentUser != null
      //     ? IconButton(
      //         onPressed: () {
      //           Route route = MaterialPageRoute(
      //             builder: (c) => MyPage(),
      //           );
      //           Navigator.pushReplacement(context, route);
      //         },
      //         icon: CircleAvatar(
      //           backgroundImage: NetworkImage(
      //             EcommerceApp.sharedPreferences.getString(
      //               EcommerceApp.userAvatarUrl,
      //             ),
      //           ),
      //         ),
      //       )
      //     : IconButton(
      //         onPressed: () {
      //           Route route = MaterialPageRoute(
      //             builder: (c) => MyPage(),
      //           );
      //           Navigator.pushReplacement(context, route);
      //         },
      //         icon: Icon(Icons.perm_identity)),
      // iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: HexColor("E5E2E0"),
      title: title,

      // actions: [
      //   Stack(
      //     children: [
      //       Icon(
      //         Icons.favorite,
      //         color: mainColor,
      //         size: 35,
      //       ),
      //       Positioned(
      //         child: Stack(
      //           children: [
      //             Icon(
      //               Icons.brightness_1_outlined,
      //               size: 20,
      //               color: Colors.black,
      //             ),
      //             //todo: アイテムカウントの可視化
      //             Positioned(
      //               top: 3,
      //               bottom: 4,
      //               left: 6,
      //               child: Consumer<LikeItemCounter>(
      //                 builder: (context, counter, _) {
      //                   Provider.of<LikeItemCounter>(context, listen: false)
      //                       .displayResult();
      //                   return Text(
      //                     (EcommerceApp.sharedPreferences
      //                                 .getStringList(EcommerceApp.userLikeList)
      //                                 .length -
      //                             1)
      //                         .toString(),
      //                     style: TextStyle(
      //                         color: Colors.black,
      //                         fontSize: 12,
      //                         fontWeight: FontWeight.w500),
      //                   );
      //                 },
      //               ),
      //             ),
      //           ],
      //         ),
      //       )
      //     ],
      //   ),
      // ],
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

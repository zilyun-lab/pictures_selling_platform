// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:selling_pictures_platform/Authentication/MyPage.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Counters/Likeitemcounter.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
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
      elevation: 0,
      bottom: bottom,
      backgroundColor: HexColor("E67928"),
      title: title,
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

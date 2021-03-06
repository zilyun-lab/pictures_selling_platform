// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

class AdMobService {
  String getBannerAdUnitId() {
    // iOSとAndroidで広告ユニットIDを分岐させる
    if (Platform.isAndroid) {
      // Androidの広告ユニットID
      return 'ca-app-pub-1667936047040887/1282958246';
    } else if (Platform.isIOS) {
      // iOSの広告ユニットID
      return 'ca-app-pub-4546403287387689~3385512714';
    }
    return null;
  }

  // 表示するバナー広告の高さを計算
  double getHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final percent = (height * 0.06).toDouble();

    return percent;
  }
}

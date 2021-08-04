// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:selling_pictures_platform/Authentication/Notification.dart';
import 'package:selling_pictures_platform/Authentication/ProceedsRequests.dart';
import 'package:selling_pictures_platform/Authentication/updateProfile.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/AllProviders.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'FAQ.dart';
import 'PrivacyPolicyEtc.dart';
import 'login.dart';

class MyPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoStreamProvider);
    final info = userInfo.data?.value;
    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: myFloatingActionButton(
          "出品", bottomSheetItems(context), Icons.camera_alt_outlined),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 75,
                  ),
                  Neumorphic(
                    style: NeumorphicStyle(
                        depth: NeumorphicTheme.embossDepth(context),
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(10)),
                        shadowDarkColorEmboss: Colors.black87,
                        shadowLightColorEmboss: Colors.black26,
                        color: bgColor),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(10)),
                                  color: bgColor),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Neumorphic(
                                      style: NeumorphicStyle(
                                        boxShape: NeumorphicBoxShape.circle(),
                                        // depth: 19,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                            EcommerceApp.sharedPreferences
                                                .getString(
                                              EcommerceApp.userAvatarUrl,
                                            ),
                                          )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DefaultTextStyle(
                                      style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      child: new Text(info.first.name)),
                                  myPageProceeds(),
                                ],
                              ),
                            ),
                          ),
                          myPageIconGrid(context),
                        ],
                      ),
                    ),
                  ),
                  myPageList(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

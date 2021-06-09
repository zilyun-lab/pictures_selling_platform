import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:selling_pictures_platform/Widgets/myDrawer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MyPage.dart';
import 'login.dart';

class PublicUserPage extends StatelessWidget {
  final String uid;
  final String imageUrl;
  final String name;
  final String description;
  PublicUserPage(
      {Key key, this.uid, this.imageUrl, this.description, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: HexColor("e5e2df"),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              (80),
                            ),
                          ),
                          elevation: 8,
                          child: Container(
                            height: 100,
                            width: 100,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(imageUrl),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0, left: 5),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 10.0,
                                ),
                                child: Text(
                                  description,
                                  style: TextStyle(fontSize: 12),
                                ),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: BubbleBorder(
                                    width: 1,
                                    radius: 10,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: InkWell(
                                    onTap: () {
                                      launch(EcommerceApp.sharedPreferences
                                          .getString(EcommerceApp.TwitterURL));
                                    },
                                    child: EcommerceApp.sharedPreferences
                                                .getString(
                                                    EcommerceApp.TwitterURL) !=
                                            ""
                                        ? FaIcon(
                                            FontAwesomeIcons.twitterSquare,
                                            color: Colors.blueGrey,
                                            size: 40,
                                          )
                                        : FaIcon(
                                            FontAwesomeIcons.twitterSquare,
                                            color: Colors.white54,
                                            size: 40,
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: InkWell(
                                    onTap: () {
                                      launch(EcommerceApp.sharedPreferences
                                          .getString(EcommerceApp.FaceBookURL));
                                    },
                                    child: EcommerceApp.sharedPreferences
                                                .getString(
                                                    EcommerceApp.FaceBookURL) !=
                                            ""
                                        ? FaIcon(
                                            FontAwesomeIcons.facebookSquare,
                                            color: Colors.blueGrey,
                                            size: 40,
                                          )
                                        : FaIcon(
                                            FontAwesomeIcons.facebookSquare,
                                            color: Colors.white54,
                                            size: 40,
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: InkWell(
                                    onTap: () {
                                      launch(EcommerceApp.sharedPreferences
                                          .getString(
                                              EcommerceApp.InstagramURL));
                                    },
                                    child: EcommerceApp.sharedPreferences
                                                .getString(EcommerceApp
                                                    .InstagramURL) ==
                                            ""
                                        ? FaIcon(
                                            FontAwesomeIcons.instagramSquare,
                                            color: Colors.white54,
                                            size: 40,
                                          )
                                        : FaIcon(
                                            FontAwesomeIcons.instagramSquare,
                                            color: Colors.blueGrey,
                                            size: 40,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 8),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: EcommerceApp.firestore
                        .collection(EcommerceApp.collectionUser)
                        .doc(EcommerceApp.sharedPreferences
                            .getString(EcommerceApp.userUID))
                        .collection("MyUploadItems")
                        .snapshots(),
                    builder: (context, dataSnapshot) {
                      return !dataSnapshot.hasData
                          ? Center(
                              child: circularProgress(),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 1),
                              child: Text(
                                "出品数：" +
                                    dataSnapshot.data.docs.length.toString(),
                                style: TextStyle(fontSize: 25),
                              ),
                            );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: EcommerceApp.firestore
                          .collection(EcommerceApp.collectionUser)
                          .doc(uid)
                          .collection("MyUploadItems")
                          .orderBy(
                            "publishedDate",
                            descending: true,
                          )
                          .snapshots(),
                      builder: (context, dataSnapshot) {
                        return !dataSnapshot.hasData
                            ? Center(
                                child: circularProgress(),
                              )
                            : GridView.builder(
                                itemCount: dataSnapshot.data.docs.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (context, index) {
                                  ItemModel model = ItemModel.fromJson(
                                    dataSnapshot.data.docs[index].data(),
                                  );
                                  return Card(
                                    child: sourceInfoForMain(model, context),
                                  );
                                },
                              );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

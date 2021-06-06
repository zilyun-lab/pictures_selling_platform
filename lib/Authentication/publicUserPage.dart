import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:selling_pictures_platform/Widgets/myDrawer.dart';

import 'MyPage.dart';

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
              Text(name),
              Text(description),
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
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (context, index) {
                                  ItemGridModel model = ItemGridModel.fromJson(
                                    dataSnapshot.data.docs[index].data(),
                                  );
                                  return Card(
                                    child: sourceInfo(model, context),
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

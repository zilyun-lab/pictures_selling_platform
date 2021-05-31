import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:selling_pictures_platform/main.dart';

class MyUploadItems extends StatelessWidget {
  const MyUploadItems({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: MyAppBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
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
                                        dataSnapshot.data.docs.length
                                            .toString(),
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
                              .doc(EcommerceApp.sharedPreferences
                                  .getString(EcommerceApp.userUID))
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
                                      return sourceInfoForMain(model, context);
                                    },
                                  );
                          }),
                    ),
                  ),
                ],
              ),
            )));
  }
}

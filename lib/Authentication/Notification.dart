import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';

class UserNotification extends StatelessWidget {
  const UserNotification({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: MyAppBar(),
            body: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 3, right: 3),
              child: StreamBuilder<QuerySnapshot>(
                stream: EcommerceApp.firestore
                    .collection(EcommerceApp.collectionUser)
                    .doc(EcommerceApp.sharedPreferences
                        .getString(EcommerceApp.userUID))
                    .collection("Notify")
                    .snapshots(),
                builder: (context, dataSnapshot) {
                  return !dataSnapshot.hasData
                      ? Center(
                          child: circularProgress(),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(
                                  '${dataSnapshot.data.docs[index]["orderBy"]} さんより ${dataSnapshot.data.docs[index]["productIDs"]} を購入いただきました。\n取引完了まで少々お待ちください。',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            );
                          },
                          itemCount: dataSnapshot.data.docs.length,
                        );
                },
              ),
            )));
    ;
  }
}

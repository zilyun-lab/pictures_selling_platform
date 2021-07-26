// Flutter imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Config/config.dart';

// Project imports:
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/UploadItemList.dart';
import 'package:selling_pictures_platform/Models/UploadItemModel.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';

class MyUploadItems extends StatelessWidget {
  const MyUploadItems({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text("出品履歴"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(EcommerceApp.sharedPreferences
                        .getString(EcommerceApp.userUID))
                    .collection("MyUploadItems")
                    .snapshots(),
                builder: (c, snap) {
                  return !snap.hasData
                      ? Container()
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          shrinkWrap: true,
                          itemCount: snap.data.docs.length,
                          itemBuilder: (context, index) {
                            ItemModel model = ItemModel.fromJson(
                                snap.data.docs[index].data());
                            return sourceInfoForMain(model, context);
                          },
                        );
                }),
          ),
        ),
      ),
    );
  }

  beginUpload(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: HexColor("E67928").withOpacity(0.8),
          child: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.insert_emoticon,
                  color: Colors.black,
                ),
                Text("まだ出品していません"),
                Text("何か出品してみませんか？"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

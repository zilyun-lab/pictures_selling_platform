import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:flutter/services.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/main.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("e5e2df"),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Route route = MaterialPageRoute(
                  builder: (c) => MainPage(),
                );
                Navigator.pushReplacement(context, route);
              },
              icon: Icon(
                Icons.home_outlined,
                size: 35,
              )),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(
            "注文履歴",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w100,
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.black,
                ),
                onPressed: () {
                  SystemNavigator.pop();
                })
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: EcommerceApp.firestore
              .collection(EcommerceApp.collectionUser)
              .doc(EcommerceApp.sharedPreferences
                  .getString(EcommerceApp.userUID))
              .collection(EcommerceApp.collectionOrders)
              .orderBy(
                "orderTime",
                descending: true,
              )
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("items")
                            .where("shortInfo",
                                isEqualTo: snapshot.data.docs[index]
                                    ["productIDs"])
                            .get(),
                        builder: (c, snap) {
                          return snap.hasData
                              ? OrderCard(
                                  totalPrice: snapshot.data.docs[index]
                                      ["totalPrice"],
                                  itemCount: snap.data.docs.length,
                                  data: snap.data.docs,
                                  orderID: snapshot.data.docs[index].id,
                                )
                              : Center(
                                  child: circularProgress(),
                                );
                        },
                      );
                    },
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}

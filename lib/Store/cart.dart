import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Address/address.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:selling_pictures_platform/Widgets/loadingWidget.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Counters/cartitemcounter.dart';
import 'package:selling_pictures_platform/Counters/totalMoney.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Widgets/myDrawer.dart';
import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(
      context,
      listen: false,
    ).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (EcommerceApp.sharedPreferences
                    .getStringList(
                      EcommerceApp.userCartList,
                    )
                    .length ==
                1) {
              Fluttertoast.showToast(msg: "カート内に作品が追加されていません");
            } else {
              Route route = MaterialPageRoute(
                builder: (c) => Address(totalAmount: totalAmount),
              );
              Navigator.pushReplacement(
                context,
                route,
              );
            }
          },
          label: Text("注文手続きへ"),
          backgroundColor: Colors.black,
          icon: Icon(Icons.navigate_next),
        ),
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Consumer2<TotalAmount, CartItemCounter>(
                builder: (context, amountProvider, cartProvider, c) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: cartProvider.count == 0
                        ? Container()
                        : Column(
                            children: [
                              Text("マイカート"),
                              Text(
                                "合計金額" +
                                    amountProvider.totalAmount.toString() +
                                    "円",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: EcommerceApp.firestore
                    .collection("items")
                    .where("shortInfo",
                        whereIn: EcommerceApp.sharedPreferences
                            .getStringList(EcommerceApp.userCartList))
                    .snapshots(),
                builder: (
                  context,
                  snapshot,
                ) {
                  return !snapshot.hasData
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: circularProgress(),
                          ),
                        )
                      : snapshot.data.docs.length == 0
                          ? beginBuildingCart()
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  ItemModel model = ItemModel.fromJson(
                                    snapshot.data.docs[index].data(),
                                  );
                                  if (index == 0) {
                                    totalAmount = 0;
                                    totalAmount = model.price + totalAmount;
                                  } else {
                                    totalAmount = totalAmount + model.price;
                                  }
                                  if (snapshot.data.docs.length - 1 == index) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                      (t) {
                                        Provider.of<TotalAmount>(
                                          context,
                                          listen: false,
                                        ).display(totalAmount);
                                      },
                                    );
                                  }
                                  return sourceInfo(
                                    model,
                                    context,
                                    removeCartFunction: () =>
                                        removeItemFromCart(model.shortInfo),
                                  );
                                },
                                childCount: snapshot.hasData
                                    ? snapshot.data.docs.length
                                    : 0,
                              ),
                            );
                })
          ],
        ),
      ),
    );
  }

  beginBuildingCart() {
    return SliverToBoxAdapter(
      child: Card(
        color: Colors.black.withOpacity(
          0.1,
        ),
        child: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_emoticon,
                color: Colors.black,
              ),
              Text("カートが空です"),
              Text("何かカートに追加してみましょう"),
            ],
          ),
        ),
      ),
    );
  }

  removeItemFromCart(String shortInfoAsID) {
    List tempCartList = EcommerceApp.sharedPreferences.getStringList(
      EcommerceApp.userCartList,
    );
    tempCartList.remove(
      shortInfoAsID,
    );
    EcommerceApp.firestore
        .collection(
          EcommerceApp.collectionUser,
        )
        .doc(
          EcommerceApp.sharedPreferences.getString(
            EcommerceApp.userUID,
          ),
        )
        .update(
      {
        EcommerceApp.userCartList: tempCartList,
      },
    ).then(
      (v) {
        Fluttertoast.showToast(
          msg: "マイカートから削除しました",
        );
        EcommerceApp.sharedPreferences.setStringList(
          EcommerceApp.userCartList,
          tempCartList,
        );
        Provider.of<CartItemCounter>(
          context,
          listen: true,
        ).displayResult();

        totalAmount = 0;
      },
    );
  }
}

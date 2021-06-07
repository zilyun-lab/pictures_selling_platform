import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Address/address.dart';
import 'package:selling_pictures_platform/Models/address.dart';
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
import 'OrderDetailsPage.dart';

class PaymentPage extends StatefulWidget {
  final String addressId;
  final double totalAmount;
  final ItemModel itemModel;
  final String postBy;

  PaymentPage(
      {Key key, this.totalAmount, this.addressId, this.itemModel, this.postBy})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  _PaymentPageState({Key key, this.itemModel, this.totalAmount, this.postBy});
  double totalAmount;
  final ItemModel itemModel;
  final String postBy;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = [];
    totalAmount = 0;
    Provider.of<TotalAmount>(
      context,
      listen: false,
    ).display(0);
  }

  List list = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            addOrderDetails();
            //notifyToSeller();
          },
          label: Text("注文する"),
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
                      padding: EdgeInsets.all(
                        8,
                      ),
                      child: cartProvider.count == 0
                          ? Container()
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "マイカート",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "ご注文はこちらでお間違い無いですか？",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "決済は代金引換のみとさせていただきます。\n（クレジット決済等は順次対応予定）",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w100,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "合計金額　${amountProvider.totalAmount.toString()}円",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ));
                  // ):Coontainer());
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
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (t) {
                                      Provider.of<TotalAmount>(
                                        context,
                                        listen: false,
                                      ).display(totalAmount);
                                    },
                                  );
                                }
                                list.add(model.shortInfo);
                                return sourceInfoForMain(
                                  model,
                                  context,
                                  removeCartFunction: () =>
                                      removeItemFromCart(model.shortInfo),
                                );

                                //return Text(model.postBy);
                              },
                              childCount: snapshot.hasData
                                  ? snapshot.data.docs.length
                                  : 0,
                            ),
                          );
              },
            ),
          ],
        ),
      ),
    );
  }

  notifyToSeller() {
    print(list);
    // list.toSet().toList().forEach((val) {
    //   print(val);
    // });
  }

  addOrderDetails() {
    writeOrderDetailsForUser({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "代金引換",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
      //"sellBy":
    });

    writeOrderDetailsForAdmin({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: "代金引換",
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
    }).whenComplete(() => {
          emptyCartNow(),
        });
  }

  emptyCartNow() {
    EcommerceApp.sharedPreferences.setStringList(
      EcommerceApp.userCartList,
      ["garbageValue"],
    );
    List tempList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);

    FirebaseFirestore.instance
        .collection("users")
        .doc(
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
        )
        .update(
      {
        EcommerceApp.userCartList: tempList,
      },
    ).then((value) {
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
    Fluttertoast.showToast(msg: "注文を承りました");

    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data["orderTime"])
        .set(data);
  }

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data["orderTime"])
        .set(data);
  }

  beginBuildingCart() {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(
              0.5,
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
    List tempCartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    tempCartList.remove(shortInfoAsID);
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .update(
      {EcommerceApp.userCartList: tempCartList},
    ).then(
      (v) {
        Fluttertoast.showToast(msg: "マイカートから削除しました");
        EcommerceApp.sharedPreferences
            .setStringList(EcommerceApp.userCartList, tempCartList);
        Provider.of<CartItemCounter>(context, listen: true).displayResult();

        totalAmount = 0;
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Address/address.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
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

class LikePage extends StatefulWidget {
  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  final mainColor = HexColor("E67928");
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
        backgroundColor: HexColor("E5E2E0"),
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Consumer2<TotalAmount, LikeItemCounter>(
                builder: (context, amountProvider, likeProvider, c) {
                  return Padding(
                    padding: EdgeInsets.all(
                      8,
                    ),
                    child: likeProvider.count == 0
                        ? Container()
                        : Text(
                            "いいねした作品",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
                            .getStringList(EcommerceApp.userLikeList))
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
                                  ItemGridModel model = ItemGridModel.fromJson(
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
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 12,
                                        ),
                                        child: ListTile(
                                          trailing: IconButton(
                                            color: Colors.black,
                                            icon: Icon(Icons.delete),
                                            onPressed: () => removeItemFromLike(
                                                model.shortInfo, context),
                                          ),
                                          title: Text(
                                            model.shortInfo.toString(),
                                          ),
                                          leading:
                                              Image.network(model.thumbnailUrl),
                                          onTap: () {
                                            Route route = MaterialPageRoute(
                                              builder: (c) =>
                                                  ProductPage(itemModel: model),
                                            );
                                            Navigator.pushReplacement(
                                              context,
                                              route,
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8,
                                        ),
                                        child: Divider(),
                                      ),
                                    ],
                                  );

                                  // return sourceInfo(
                                  //   model,
                                  //   context,
                                  //   removeCartFunction: () =>
                                  //       removeItemFromCart(model.shortInfo),
                                  // );
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
              Text("まだいいねしていません"),
              Text("何かいいねしてみましょう"),
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

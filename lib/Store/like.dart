import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Address/address.dart';
import 'package:selling_pictures_platform/Models/GetLikeItemsModel.dart';
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
        body: ChangeNotifierProvider<GetLikeItemsModel>(
          create: (_) => GetLikeItemsModel()..fetchItems(),
          child: Column(
            children: [
              Consumer2<TotalAmount, LikeItemCounter>(
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
              SingleChildScrollView(
                child: Consumer<GetLikeItemsModel>(
                  builder: (context, model, child) {
                    final items = model.items;
                    final listTiles = items
                        .map((item) => Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Route route = MaterialPageRoute(
                                        builder: (c) => ProductPage(
                                          thumbnailURL: item.thumbnailUrl,
                                          shortInfo: item.shortInfo,
                                          longDescription: item.longDescription,
                                          price: item.price,
                                          attribute: item.attribute,
                                          postBy: item.postBy,
                                          Stock: item.Stock,
                                          id: item.id,
                                        ),
                                      );
                                      Navigator.pushReplacement(
                                        context,
                                        route,
                                      );
                                    },
                                    leading: Image.network(
                                      item.thumbnailUrl,
                                      height: 50,
                                      fit: BoxFit.scaleDown,
                                    ),
                                    title: Text(item.shortInfo.toString()),
                                    trailing: IconButton(
                                      color: Colors.black,
                                      icon: Icon(Icons.delete),
                                      onPressed: () => removeItemFromLike(
                                          item.shortInfo, context),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: Divider(),
                                  )
                                ],
                              ),
                            ))
                        .toList();
                    return items.length == 0
                        ? beginBuildingCart()
                        : ListView(
                            shrinkWrap: true,
                            children: listTiles,
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  beginBuildingCart() {
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
                Text("まだいいねしていません"),
                Text("何かいいねしてみませんか？"),
              ],
            ),
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

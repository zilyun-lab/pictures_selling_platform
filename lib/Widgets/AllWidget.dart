import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Admin/PostCard.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Counters/Likeitemcounter.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/HomeItem(provider).dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Store/like.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';

Widget infoTiles({
  TextEditingController controller,
  String hintText,
  Widget trailing,
  String alert,
  TextInputType keyboard,
}) {
  return ListTile(
    trailing: trailing,
    title: TextFormField(
      keyboardType: keyboard,
      validator: (val) => controller.text.isEmpty ? alert : null,
      style: TextStyle(color: Colors.deepPurpleAccent),
      controller: controller,
      decoration: InputDecoration(
        // labelStyle: TextStyle(color: mainColor),
        border: InputBorder.none,
        labelText: hintText,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    ),
  );
}

Widget uploadTitle(String title, double pad) {
  return Padding(
    padding: EdgeInsets.all(pad),
    child: Text(title),
  );
}

Widget sourceInfoForMain(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return Card(
    color: HexColor("e5e2df"),
    child: InkWell(
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (c) => ProductPage(
            thumbnailURL: model.thumbnailUrl,
            shortInfo: model.shortInfo,
            longDescription: model.longDescription,
            price: model.price,
            attribute: model.attribute,
            postBy: model.postBy,
            Stock: model.Stock,
            id: model.id,
          ),
        );
        Navigator.pushReplacement(
          context,
          route,
        );
      },
      splashColor: Colors.black,
      child: Column(
        children: [
          Center(
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  model.thumbnailUrl,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 135,
                ),
              ),
              width: MediaQuery.of(context).size.width,
              // color: Colors.white,
            ),
          ),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      children: [
                        DefaultTextStyle(
                          style: new TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          child: new Text(model.shortInfo),
                        ),
                        DefaultTextStyle(
                          style: new TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: mainColor),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          child: new Text(
                            model.price.toString() + "円",
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

//todo:以下商品ページ

void checkItemInLike(String shortInfoAsID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userLikeList)
          .contains(shortInfoAsID)
      ? removeItemFromLike(shortInfoAsID, context)
      : addItemToLike(shortInfoAsID, context);
  Route route = MaterialPageRoute(
    builder: (c) => LikePage(),
  );
  Navigator.pushReplacement(context, route);
}

Future<bool> onLikeButtonTapped(
    bool isLiked, String shortInfoAsID, BuildContext context) async {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userLikeList)
          .contains(shortInfoAsID)
      ? removeItemFromLike(shortInfoAsID, context)
      : addItemToLike(shortInfoAsID, context);
  return !isLiked;
}

addItemToLike(
  String shortInfoAsID,
  BuildContext context,
) {
  List tempLikeList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userLikeList);
  tempLikeList.add(shortInfoAsID);
  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .update({EcommerceApp.userLikeList: tempLikeList}).then(
    (v) {
      Fluttertoast.showToast(msg: "いいねしました");
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userLikeList, tempLikeList);
      Provider.of<LikeItemCounter>(context, listen: false).displayResult();
    },
  );
}

removeItemFromLike(
  String shortInfoAsID,
  BuildContext context,
) {
  List tempCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userLikeList);
  tempCartList.remove(shortInfoAsID);
  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .update(
    {EcommerceApp.userLikeList: tempCartList},
  ).then(
    (v) {
      Fluttertoast.showToast(msg: "マイいいねから削除しました");
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userLikeList, tempCartList.cast());

      //totalAmount = 0;
    },
  );
}

Widget HomeItemFrame(context, Items item) {
  Container(
    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        elevation: 0,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: InkWell(
          onTap: () {
            Route route = MaterialPageRoute(
              builder: (c) => ProductPage(
                width: item.itemWidth,
                height: item.itemHeight,
                shipsDate: item.shipsDate,
                postName: item.postName,
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
          splashColor: Colors.black,
          child: Column(
            children: [
              Center(
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      item.thumbnailUrl,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 135,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.white,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          children: [
                            DefaultTextStyle(
                              style: new TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              child: new Text(item.shortInfo),
                            ),
                            DefaultTextStyle(
                              style: new TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: mainColor),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              child: new Text(
                                item.price.toString() + "円",
                              ),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

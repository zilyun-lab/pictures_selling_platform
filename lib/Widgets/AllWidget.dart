// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:selling_pictures_platform/Address/addAddress.dart';
import 'package:selling_pictures_platform/Admin/Copy.dart';
import 'package:selling_pictures_platform/Admin/MyUploadItems.dart';
import 'package:selling_pictures_platform/Admin/PostCard.dart';
import 'package:selling_pictures_platform/Admin/Sticker.dart';
import 'package:selling_pictures_platform/Admin/uploadItems.dart';
import 'package:selling_pictures_platform/Authentication/ProceedsRequests.dart';
import 'package:selling_pictures_platform/Authentication/SubmitBankAccount.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Authentication/publicUserPage.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Counters/Likeitemcounter.dart';
import 'package:selling_pictures_platform/Models/GetLikeItemsModel.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/HomeItem(provider).dart';
import 'package:selling_pictures_platform/Models/LikeItemsList.dart';
import 'package:selling_pictures_platform/Models/UploadItemList.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Orders/CheckOutPage.dart';
import 'package:selling_pictures_platform/Orders/TransactionPage.dart';
import 'package:selling_pictures_platform/Orders/myOrders.dart';
import 'package:selling_pictures_platform/Store/UpdateItem.dart';
import 'package:selling_pictures_platform/Store/like.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import '../main.dart';

final lilBrown = HexColor("FFB47C");

final mainColorOfLEEWAY = HexColor("E67928");
final String productID = DateTime.now().millisecondsSinceEpoch.toString();
final bgColor = HexColor("#e0e5ec");

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
      maxLines: null,
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
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 20,
      ),
      Padding(
        padding: EdgeInsets.all(pad),
        child: Text(title),
      ),
    ],
  );
}

Widget sourceInfoForMain(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(
        builder: (c) => ProductPage(
          id: model.id,
        ),
      );
      Navigator.push(
        context,
        route,
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Neumorphic(
        child: Container(
          child: Image.network(
            model.thumbnailUrl,
            fit: BoxFit.cover,
            width: 100,
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          width: MediaQuery.of(context).size.width,
          // color: Colors.white,
        ),
      ),
    ),
  );
}

//todo:以下商品ページ

void checkItemInLike(String itemID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userLikeList)
          .contains(itemID)
      ? removeItemFromLike(itemID, context)
      : addItemToLike(itemID, context);
}

Future<bool> onLikeButtonTapped(
    bool isLiked, String itemID, BuildContext context) async {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userLikeList)
          .contains(itemID)
      ? removeItemFromLike(itemID, context)
      : addItemToLike(itemID, context);
  return !isLiked;
}

addItemToLike(
  String itemID,
  BuildContext context,
) {
  List tempLikeList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userLikeList);
  tempLikeList.add(itemID);
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
  String itemID,
  BuildContext context,
) {
  List tempCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userLikeList);
  tempCartList.remove(itemID);
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

Widget myFloatingActionButton(String title, Function func, IconData icon) {
  return Container(
    width: 100,
    height: 100,
    child: NeumorphicFloatingActionButton(
      style: NeumorphicStyle(
          color: bgColor, boxShape: NeumorphicBoxShape.circle()),
      onPressed: func,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: mainColorOfLEEWAY,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              icon,
              size: 45,
              color: mainColorOfLEEWAY,
            ),
          ],
        ),
      ),
    ),
  );
}

class KeyText extends StatelessWidget {
  final String msg;
  KeyText({Key key, this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

List<Widget> addressText(String title, String text) {
  return [
    Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: KeyText(msg: title),
    ),
    Text(text),
  ];
}

Widget sourceInfoForMains(UploadItems model, BuildContext context,
    {Color background, removeCartFunction}) {
  return Expanded(
    child: Card(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Route route = MaterialPageRoute(
            builder: (c) => ProductPage(
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
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      topLeft: Radius.circular(8)),
                  child: Image.network(
                    model.thumbnailUrl,
                    fit: BoxFit.cover,
                    width: 100,
                    height: MediaQuery.of(context).size.height * 0.15,
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
                padding: const EdgeInsets.only(
                    top: 5, right: 13.0, left: 13.0, bottom: 5),
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
                          color: mainColorOfLEEWAY),
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
          ],
        ),
      ),
    ),
  );
}

Widget buildFooter(BuildContext context) {
  final visual = Container(
    decoration: BoxDecoration(
        color: HexColor("#e0e5ec"),
        boxShadow: [
          BoxShadow(
            color: HexColor("#a3b1c6"),
            spreadRadius: 1.0,
            blurRadius: 12.0,
            offset: Offset(10, 10),
          ),
          BoxShadow(
            color: HexColor("#ffffff"),
            spreadRadius: 1.0,
            blurRadius: 10.0,
            offset: Offset(-10, -10),
          ),
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        Icons.keyboard_arrow_up_outlined,
        color: mainColorOfLEEWAY,
        size: 40,
      ),
    ),
  );
  return visual;
}

void deleteItem(String id) {
  FirebaseFirestore.instance.collection("items").doc(id).delete();
  FirebaseFirestore.instance
      .collection("users")
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .collection("MyUploadItems")
      .doc(id)
      .delete();
}

afterDeleteDialog(BuildContext context, String shortInfo) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(
          "削除完了",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content:
            Container(child: Text("$shortInfo を削除しました。\n引き続きLEEWAYをお楽しみください。")),
        actions: <Widget>[
          // ボタン領域

          ElevatedButton(
            child: Text("確認しました。"),
            onPressed: () {
              Route route = MaterialPageRoute(
                fullscreenDialog: true,
                builder: (c) => MainPage(),
              );
              Navigator.pushReplacement(
                context,
                route,
              );
            },
          ),
        ],
      );
    },
  );
}

class BubbleBorder extends ShapeBorder {
  BubbleBorder({
    @required this.width,
    @required this.radius,
  });

  final double width;
  final double radius;

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.all(width);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return getOuterPath(
      rect.deflate(width / 2.0),
      textDirection: textDirection,
    );
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    final r = radius;
    final rs = radius / 2;
    final w = rect.size.width;
    final h = rect.size.height;

    return Path()
      ..addPath(
        Path()
          ..moveTo(r, 0)
          ..lineTo(w - r, 0)
          ..arcToPoint(Offset(w, r), radius: Radius.circular(r))
          ..lineTo(w, h - rs)
          ..arcToPoint(Offset(w - r, h), radius: Radius.circular(r))
          ..lineTo(r, h)
          ..arcToPoint(Offset(0, h - r), radius: Radius.circular(r))
          ..lineTo(0, h / 2)
          ..relativeLineTo(-12, -12)
          ..lineTo(0, h / 2 - 10)
          ..lineTo(0, r)
          ..arcToPoint(Offset(r, 0), radius: Radius.circular(r)),
        Offset(rect.left, rect.top),
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black;
    canvas.drawPath(
      getOuterPath(
        rect.deflate(width / 2.0),
        textDirection: textDirection,
      ),
      paint,
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}

const boldTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 15,
  color: Colors.black,
);
const largeTextStyle = TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 20,
  color: Colors.black,
);

class StripeTransactionResponse {
  StripeTransactionResponse({
    @required this.message,
    @required this.success,
  });

  String message;
  bool success;
}

Widget userLink(Map il) {
  return Container(
    padding: EdgeInsets.all(
      12,
    ),
    child: Center(
      child: Container(
        color: HexColor("#2971E5"),
        child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(il["postBy"])
                    .snapshots(),
                builder: (context, snapshot) {
                  return snapshot.data == null
                      ? Container()
                      : InkWell(
                          onTap: () {
                            CheckOutPage(il: il);
                            Route route = MaterialPageRoute(
                              builder: (c) => PublicUserPage(
                                FB: snapshot.data["FaceBookURL"],
                                IG: snapshot.data["InstagramURL"],
                                TW: snapshot.data["TwitterURL"],
                                uid: snapshot.data.id,
                                imageUrl: snapshot.data["url"],
                                name: snapshot.data["name"],
                                description: snapshot.data["description"],
                              ),
                            );
                            Navigator.pushReplacement(context, route);
                          },
                          child: ListTile(
                            leading: Container(
                              height: 80,
                              width: 80,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    snapshot.data["url"].toString()),
                              ),
                            ),
                            title: Text(
                              '${snapshot.data["name"]}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 10.0,
                              ),
                              child: Text(
                                snapshot.data["description"].toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: BubbleBorder(
                                  width: 1,
                                  radius: 10,
                                ),
                              ),
                            ),
                          ),
                        );
                })),
      ),
    ),
  );
}

likeButton(BuildContext context, Map il) {
  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
          .snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Container()
            : snapshot.data.data()["userLike"].contains(il["id"])
                ? SizedBox(
                    width: 65,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.transparent, elevation: 0),
                      onPressed: () => checkItemInLike(il["id"], context),
                      child: Center(
                        child: Icon(
                          Icons.favorite,
                          color: Colors.pinkAccent,
                          size: 30,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    width: 65,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.transparent, elevation: 0),
                      onPressed: () => checkItemInLike(il["id"], context),
                      child: Icon(
                        Icons.favorite_outline_outlined,
                        color: Colors.pinkAccent,
                        size: 30,
                      ),
                    ),
                  );
      });
}

itemEditButton(BuildContext context, Map il, String id) {
  return Expanded(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 60,
          width: 260,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(primary: HexColor("2997E5")),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => UpdateItemInfo(
                          shortInfo: il["shortInfo"],
                          id: id,
                          longDescription: il["longDescription"],
                          price: il["price"],
                          attribute: il["attribute"])));
            },
            label: Text(
              "編集する",
              style: TextStyle(fontSize: 20),
            ),
            icon: Icon(Icons.edit),
          ),
        ),
      ),
    ),
  );
}

checkOutByNewUser(BuildContext context) {
  return InkWell(
    onTap: () {
      Route route =
          MaterialPageRoute(fullscreenDialog: true, builder: (c) => Login());
      Navigator.push(
        context,
        route,
      );
    },
    child: Container(
      color: Colors.black,
      width: MediaQuery.of(
            context,
          ).size.width *
          0.46,
      height: 50,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 45),
                child: Text(
                  "ログインして購入",
                  style: TextStyle(
                    color: Colors.white,
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

Widget deleteItemButton(BuildContext context, Function func) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: 60,
      width: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.redAccent),
        onPressed: func,
        child: Icon(
          Icons.delete,
          size: 30,
        ),
      ),
    ),
  );
}

Widget checkOutItemButton(BuildContext context, Map il, String id) {
  return Expanded(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 260,
          height: 60,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(primary: HexColor("2997E5")),
            onPressed: () {
              Route route = MaterialPageRoute(
                fullscreenDialog: true,
                builder: (c) => CheckOutPage(
                  il: il,
                  id: id,
                ),
              );
              Navigator.push(
                context,
                route,
              );
            },
            icon: Icon(Icons.shopping_cart_outlined),
            label: Center(
              child: Text(
                "購入する",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget soldOutButton(BuildContext context) {
  return Expanded(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 60,
          width: 325,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.grey),
            onPressed: () {},
            child: Text(
              "SOLD OUT",
              style: TextStyle(fontSize: 25),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget disableLikeButton(BuildContext context) {
  return Expanded(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Colors.grey),
              onPressed: () {},
              icon: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              label: Text("いいね"),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget productPageBody(String id) {
  return Center(
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("items")
              .doc(id)
              .collection("itemImages")
              .doc(id)
              .snapshots(),
          builder: (context, snapshot) {
            final imgList = snapshot.data.data()["images"];
            return CarouselSlider.builder(
              options: CarouselOptions(
                enlargeCenterPage: true,
                aspectRatio: 1.0,
                autoPlayInterval: Duration(seconds: 3),
                enableInfiniteScroll: false,
                // autoPlay: true,
              ),
              itemCount: imgList,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return Image.network(
                  snapshot.data.data()["images"][index].toString(),
                  fit: BoxFit.scaleDown,
                  height: MediaQuery.of(context).size.height,
                );
              },
            );
          }));
}

Function bottomSheetItems(
  BuildContext context,
) {
  return () {
    showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  "何を出品しますか？",
                  style: TextStyle(
                      color: mainColorOfLEEWAY, fontWeight: FontWeight.bold),
                ),
              )),
              ListTile(
                title: Text(
                  '原画',
                  style: TextStyle(color: mainColorOfLEEWAY),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (c) => OriginalUploadPage())),
              ),
              ListTile(
                title: Text(
                  '複製',
                  style: TextStyle(color: mainColorOfLEEWAY),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true, builder: (c) => Copy())),
              ),
              ListTile(
                title: Text(
                  'ステッカー',
                  style: TextStyle(color: mainColorOfLEEWAY),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true, builder: (c) => Sticker())),
              ),
              ListTile(
                title: Text(
                  'ポストカード',
                  style: TextStyle(color: mainColorOfLEEWAY),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true, builder: (c) => PostCard())),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          );
        });
  };
}

Widget mySizedBox(double height) {
  return SizedBox(
    height: height,
  );
}

Widget myPageSliderItems(
  BuildContext context,
) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: CarouselSlider(
      items: [
        sliderItem(
          context,
          "売り上げ申請",
          ProceedsRequests(),
          Icons.atm_outlined,
        ),
        sliderItem(
          context,
          "出品履歴",
          MyUploadItems(),
          Icons.brush,
        ),
        sliderItem(
          context,
          "お届け先追加",
          AddAddress(),
          Icons.add_location_alt_outlined,
        ),
        sliderItem(
          context,
          "購入取引",
          MyOrders(),
          Icons.shopping_cart_outlined,
        ),
        sliderItem(
          context,
          "販売取引",
          TransactionPage(),
          Icons.history_outlined,
        ),
      ],
      options: CarouselOptions(
        height: 85,
        viewportFraction: 0.3,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
      ),
    ),
  );
}

Widget infoTile(
    BuildContext context, IconData icon, String title, Widget func) {
  return Padding(
    padding: const EdgeInsets.only(top: 5, left: 8.0, right: 8),
    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: Neumorphic(
        style: NeumorphicStyle(
          color: bgColor,
          shadowLightColor: Colors.black.withOpacity(0.4),
          shadowDarkColor: Colors.black.withOpacity(0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (c) => func,
              );
              Navigator.push(
                context,
                route,
              );
            },
            leading: Icon(icon, color: HexColor("E67928")),
            title: Text(
              title,
              style: TextStyle(color: Colors.black87),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: HexColor("E67928"),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget sliderItem(
    BuildContext context, String title, Widget page, IconData icon) {
  return InkWell(
    onTap: () {
      EcommerceApp.auth.currentUser != null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => page,
              ))
          : null;
    },
    child: Neumorphic(
      style: NeumorphicStyle(color: bgColor),
      child: Container(
        width: 80,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(
                  icon,
                  color: mainColorOfLEEWAY,
                  size: 45,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: mainColorOfLEEWAY,
                      fontWeight: FontWeight.w100,
                      fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget logOutWidget(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: Neumorphic(
      style: NeumorphicStyle(
        color: bgColor,
        shadowLightColor: Colors.black.withOpacity(0.4),
        shadowDarkColor: Colors.black.withOpacity(0.6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text("本当にログアウトしますか？"),
                      actions: [
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("　キャンセル　")),
                            ElevatedButton(
                                onPressed: () {
                                  Route route = MaterialPageRoute(
                                    builder: (c) => Login(),
                                  );
                                  EcommerceApp.auth
                                      .signOut()
                                      .then((c) => Navigator.push(
                                            context,
                                            route,
                                          ));
                                },
                                child: Text("ログアウトする")),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ],
                    ));
          },
          leading: Icon(Icons.login_outlined, color: mainColorOfLEEWAY),
          title: Text(
            "ログアウト",
            style: TextStyle(color: Colors.black87),
          ),
          trailing:
              Icon(Icons.arrow_forward_ios, size: 18, color: mainColorOfLEEWAY),
        ),
      ),
    ),
  );
}

beforeDeleteDialog(BuildContext context, Map il, String id) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(
          "最終確認",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content:
            Container(child: Text("${il["shortInfo"]} を削除します。\n本当によろしいですか？")),
        actions: <Widget>[
          ElevatedButton(
            child: Text("キャンセル"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("確認しました。"),
            onPressed: () {
              deleteItem(id);
              Route route = MaterialPageRoute(
                // fullscreenDialog: true,
                builder: (c) => MainPage(),
              );
              Navigator.push(
                context,
                route,
              );
            },
          ),
        ],
      );
    },
  );
}

beginBuildingCart(BuildContext context, String title, String sub) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 100,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.insert_emoticon,
          color: Colors.black,
        ),
        Text(title),
        Text(sub),
      ],
    ),
  );
}

Widget sourceInfoForMainOfLikex2(LikeItems model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(
        builder: (c) => ProductPage(
          id: model.id,
        ),
      );
      Navigator.push(
        context,
        route,
      );
    },
    splashColor: Colors.black,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Neumorphic(
        child: Image.network(
          model.thumbnailUrl,
          fit: BoxFit.cover,
          width: 100,
          height: MediaQuery.of(context).size.height * 0.15,
        ),
      ),
    ),
  );
}

Widget sourceInfoForMainOfLikex1(LikeItems model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(
        builder: (c) => ProductPage(
          id: model.id,
        ),
      );
      Navigator.push(
        context,
        route,
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Neumorphic(
        child: Image.network(
          model.thumbnailUrl,
          fit: BoxFit.cover,
          width: 100,
          height: 320,
        ),
      ),
    ),
  );
}

Widget sourceInfoForMainOfLikex3(LikeItems model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(
        builder: (c) => ProductPage(
          id: model.id,
        ),
      );
      Navigator.pushReplacement(
        context,
        route,
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Neumorphic(
        child: Image.network(
          model.thumbnailUrl,
          fit: BoxFit.cover,
          width: 100,
          height: 90,
        ),
      ),
    ),
  );
}

Widget NoLikes(BuildContext context) {
  Expanded(
    child: Center(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_emoticon,
                size: 50,
                color: Colors.black,
              ),
              Text("作品をいいねしてみませんか？"),
              Text("作品をいいねしてみませんか？"),
            ],
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        color: mainColorOfLEEWAY.withOpacity(0.8),
      ),
    ),
  );
}

class MetaCard extends StatelessWidget {
  const MetaCard(this._title, this._children);

  final String _title;
  final Widget _children;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child:
                          Text(_title, style: const TextStyle(fontSize: 18))),
                  _children,
                ]))));
  }
}

Widget TransactionFinished(BuildContext context) {
  return Container(
    color: Colors.grey,
    width: MediaQuery.of(context).size.width,
    height: 50,
    child: Center(
      child: Text(
        "取引終了です。\n引き続きLEEWAYをお楽しみ下さい。",
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    ),
  );
}

Widget WaitShips(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      color: Colors.black,
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Center(
        child: Text(
          "出品者の発送をお待ち下さい",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    ),
  );
}

Widget WaitReserve(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      color: Colors.black,
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Center(
        child: Text(
          "購入者の受け取りをお待ちください。",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    ),
  );
}

Widget CancelFinished(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Center(
        child: Text(
          "この注文はキャンセルされました。",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    ),
  );
}

Widget HoldOrder(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      color: Colors.deepPurpleAccent,
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Center(
        child: Text(
          "運営によるキャンセル申請の受理検討中です。",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    ),
  );
}

Widget myNeumorphism(Widget w) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: HexColor("#e0e5ec"),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFFFFF),
            spreadRadius: 1.0,
            blurRadius: 10.0,
            offset: Offset(-5, -5),
          ),
          BoxShadow(
            color: HexColor("#a3b1c6"),
            spreadRadius: 1.0,
            blurRadius: 12.0,
            offset: Offset(2, 2),
          ),
        ]),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: HexColor("#e0e5ec"),
          boxShadow: [
            BoxShadow(
              color: HexColor("#a3b1c6"),
              spreadRadius: 1.0,
              blurRadius: 12.0,
              offset: Offset(3, 3),
            ),
            BoxShadow(
              color: HexColor("#ffffff"),
              spreadRadius: 1.0,
              blurRadius: 10.0,
              offset: Offset(-3, -3),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: w,
      ),
    ),
  );
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/GetLikeItemsModel.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:selling_pictures_platform/Counters/Likeitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

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

    // totalAmount = 0;
    // Provider.of<TotalAmount>(
    //   context,
    //   listen: false,
    // ).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor("#E67928"),
        body: ChangeNotifierProvider<GetLikeItemsModel>(
          create: (_) => GetLikeItemsModel()..fetchItems(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: HexColor("e5e2df"),
                    borderRadius: BorderRadius.all(
                      Radius.circular(125),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Consumer<GetLikeItemsModel>(
                      builder: (context, model, child) {
                        final items = model.items;
                        final listTiles = items
                            .map((item) => Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: mainColor, width: 3),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        Route route = MaterialPageRoute(
                                          builder: (c) => ProductPage(
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
                                      title: Text(
                                        item.shortInfo.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        color: Colors.black,
                                        icon: Icon(
                                          Icons.delete,
                                          color: mainColor,
                                        ),
                                        onPressed: () => removeItemFromLike(
                                            item.shortInfo, context),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList();
                        return items.length == 0
                            ? Text(EcommerceApp.sharedPreferences
                                .getStringList(EcommerceApp.userLikeList)
                                .toString())
                            : ListView(
                                shrinkWrap: true,
                                children: listTiles,
                              );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/GetLikeItemsModel.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:selling_pictures_platform/Counters/Likeitemcounter.dart';
import 'package:selling_pictures_platform/Counters/totalMoney.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
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

    totalAmount = 0;
    Provider.of<TotalAmount>(
      context,
      listen: false,
    ).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("e5e2df"),
      body: ChangeNotifierProvider<GetLikeItemsModel>(
        create: (_) => GetLikeItemsModel()..fetchItems(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      color: HexColor("#E67928"),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(90),
                        bottomRight: Radius.circular(90),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.1,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.88,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
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
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                              ),
                                              child: ListTile(
                                                onTap: () {
                                                  Route route =
                                                      MaterialPageRoute(
                                                    builder: (c) => ProductPage(
                                                      thumbnailURL:
                                                          item.thumbnailUrl,
                                                      shortInfo: item.shortInfo,
                                                      longDescription:
                                                          item.longDescription,
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
                                                title: Text(
                                                  item.shortInfo.toString(),
                                                  style: TextStyle(
                                                    color: mainColor,
                                                  ),
                                                ),
                                                trailing: IconButton(
                                                  color: Colors.black,
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: mainColor,
                                                  ),
                                                  onPressed: () =>
                                                      removeItemFromLike(
                                                          item.shortInfo,
                                                          context),
                                                ),
                                              ),
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
                              )),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.08,
                    left: MediaQuery.of(context).size.width * 0.425,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: mainColor,
                        size: 50,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.7),
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.25,
                  )
                ],
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
}

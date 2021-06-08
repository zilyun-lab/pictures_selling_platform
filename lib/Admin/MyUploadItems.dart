import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Authentication/login.dart';
import 'package:selling_pictures_platform/Models/UploadItemModel.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';

class MyUploadItems extends StatelessWidget {
  const MyUploadItems({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: ChangeNotifierProvider<UploadItemModel>(
          create: (_) => UploadItemModel()..fetchItems(),
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                slivers: [
                  Consumer<UploadItemModel>(
                    builder: (context, model, child) {
                      final items = model.items;
                      return items.length == 0
                          ? SliverToBoxAdapter(child: Container())
                          : SliverToBoxAdapter(
                              child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 8),
                              child: Text(
                                "出品数：" + items.length.toString(),
                                style: TextStyle(fontSize: 25),
                              ),
                            ));
                    },
                  ),
                  Consumer<UploadItemModel>(
                    builder: (context, model, child) {
                      final items = model.items;
                      return items.length == 0
                          ? SliverToBoxAdapter(child: beginUpload(context))
                          : SliverGrid.count(
                              crossAxisCount: 3,
                              children: items
                                  .map((item) => Card(
                                        color: HexColor("e5e2df"),
                                        child: InkWell(
                                          onTap: () {
                                            Route route = MaterialPageRoute(
                                              builder: (c) => ProductPage(
                                                thumbnailURL: item.thumbnailUrl,
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
                                          splashColor: Colors.black,
                                          child: Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  Center(
                                                    child: SizedBox(
                                                      child: Container(
                                                        child: Image.network(
                                                          item.thumbnailUrl,
                                                          fit: BoxFit.scaleDown,
                                                          width: 100,
                                                          height: 111.5,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 65.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 8.0,
                                                                right: 8),
                                                        child: Container(
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              "¥" +
                                                                  (item.price)
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            );
                    },
                  ),
                ],
              ),
            ),
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

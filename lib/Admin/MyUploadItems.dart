import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/UploadItemModel.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';
import 'package:selling_pictures_platform/Models/UploadItemList.dart';

class MyUploadItems extends StatelessWidget {
  const MyUploadItems({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          title: Text("出品履歴"),
        ),
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
                              crossAxisCount: 2,
                              children: items
                                  .map((item) =>
                                      sourceInfoForMains(item, context))
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

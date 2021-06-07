import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selling_pictures_platform/Models/GetLikeItemsModel.dart';
import 'package:selling_pictures_platform/Models/UploadItemModel.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:selling_pictures_platform/Widgets/customAppBar.dart';

class TestPage extends StatelessWidget {
  const TestPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: ChangeNotifierProvider<GetLikeItemsModel>(
          create: (_) => GetLikeItemsModel()..fetchItems(),
          child: Consumer<GetLikeItemsModel>(builder: (context, model, child) {
            final items = model.items;
            final listTiles = items
                .map((item) => ListTile(
                      leading: Image.network(item.thumbnailUrl),
                      title: Text(item.shortInfo.toString()),
                      trailing: IconButton(
                        color: Colors.black,
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            removeItemFromLike(item.shortInfo, context),
                      ),
                    ))
                .toList();
            return ListView(
              children: listTiles,
            );
          }),
        ),
      ),
    );
  }
}

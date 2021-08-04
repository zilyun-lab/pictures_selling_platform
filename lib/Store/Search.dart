// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:selling_pictures_platform/Admin/Copy.dart';
import 'package:selling_pictures_platform/Models/AllProviders.dart';

// Project imports:
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/allList.dart';
import 'package:selling_pictures_platform/Models/item.dart';
import 'package:selling_pictures_platform/Store/product_page.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import '../main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchProduct extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = useState("");
    final colorQuery = useState("");
    final priceQuery = useState(0.0);
    final selectedItem1 = useState("レッド");
    final _labelText = useState("");
    final _controller = useTabController(initialLength: 3);
    final _index = useState(0);

    final AsyncValue search =
        ref.watch(searchByWordStreamProvider(query.value));
    final AsyncValue price =
        ref.watch(searchByPriceStreamProvider(priceQuery.value));
    final AsyncValue color =
        ref.watch(searchByColorStreamProvider(colorQuery.value));

    _controller.addListener(() {
      _index.value = _controller.index;
    });
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TabBar(
              tabs: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("作品名検索"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("金額検索"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("カラー検索"),
                ),
              ],
              controller: _controller,
              isScrollable: true,
              enableFeedback: false,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              unselectedLabelStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              labelColor: mainColorOfLEEWAY,
              unselectedLabelColor: Colors.blueAccent,
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Container(
                child: TabBarView(
              controller: _controller,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      searchWidget(context, query),
                      search.when(
                          data: (items) {
                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              shrinkWrap: true,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                // ItemModel model = ItemModel.fromJson(items
                                //     );
                                return sourceInfoForMain(item, context);
                              },
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) => Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "お探しの作品が見つかりませんでした",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ))
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      searchPriceWidget(_labelText, priceQuery),
                      price.when(
                          data: (items) {
                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              shrinkWrap: true,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                // ItemModel model = ItemModel.fromJson(items
                                //);
                                return sourceInfoForMain(item, context);
                              },
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) => Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "お探しの作品が見つかりませんでした",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ))
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      searchColorWidget(selectedItem1, colorQuery),
                      color.when(
                          data: (items) {
                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              shrinkWrap: true,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                // ItemModel model = ItemModel.fromJson(items
                                //);
                                return sourceInfoForMain(item, context);
                              },
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) => Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "お探しの作品が見つかりませんでした",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ))
                    ],
                  ),
                )
              ],
            )),
          )
        ],
      ),
    );
  }

  Widget searchWidget(BuildContext context, ValueNotifier<String> query) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Neumorphic(
        margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
        style: NeumorphicStyle(
            depth: NeumorphicTheme.embossDepth(context),
            boxShape: NeumorphicBoxShape.stadium(),
            color: bgColor),
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 45,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 15,
                ),
                child: Icon(
                  Icons.search,
                  color: Colors.blueGrey,
                ),
              ),
              Flexible(
                  child: Padding(
                padding: EdgeInsets.only(
                  left: 8,
                ),
                child: TextField(
                  onChanged: (val) {
                    query.value = val;
                    print(query.value);
                  },
                  decoration: InputDecoration.collapsed(hintText: "作品を探す"),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  changeToInt(double d) {
    return d.toInt();
  }

  Widget searchPriceWidget(
      ValueNotifier<String> _labelText, ValueNotifier<double> priceQuery) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Neumorphic(
                  style: NeumorphicStyle(
                      color: bgColor,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(45))),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "金額：${_labelText.value}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    NeumorphicButton(
                      onPressed: () {
                        if (priceQuery.value > 0) {
                          priceQuery.value = priceQuery.value - 1000;
                          _labelText.value =
                              '${changeToInt(priceQuery.value)} 円';
                        }
                      },
                      child: Icon(Icons.remove),
                      style: NeumorphicStyle(
                          boxShape: NeumorphicBoxShape.circle()),
                    ),
                    NeumorphicButton(
                      onPressed: () {
                        priceQuery.value = priceQuery.value + 1000;
                        _labelText.value = '${changeToInt(priceQuery.value)} 円';
                      },
                      child: Icon(Icons.add),
                      style: NeumorphicStyle(
                          boxShape: NeumorphicBoxShape.circle()),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Neumorphic(
            style: NeumorphicStyle(
                color: bgColor,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(45))),
            child: Slider(
              value: priceQuery.value,
              min: 0,
              max: 1000000,
              divisions: priceQuery.value <= 50000 ? 1000 : 100,
              activeColor: mainColorOfLEEWAY,
              inactiveColor: Colors.blueAccent,
              onChanged: (double value) {
                priceQuery.value = value.roundToDouble();
                _labelText.value = '${changeToInt(priceQuery.value)} 円';
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget searchColorWidget(
    ValueNotifier<String> selectedItem1,
    ValueNotifier<String> colorQuery,
  ) {
    final map = Map.fromIterables(
        color1.map((e) => e.key).toList(), color1.map((e) => e.value).toList());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Neumorphic(
            style: NeumorphicStyle(
                color: bgColor,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(45))),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                text: TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "選択カラー：",
                    ),
                    TextSpan(
                      text: selectedItem1.value,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: map[selectedItem1]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Neumorphic(
            style: NeumorphicStyle(
                color: bgColor,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(45))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(border: InputBorder.none),
                dropdownColor: bgColor,
                isExpanded: true,
                value: selectedItem1.value,
                onChanged: (String newValue) {
                  selectedItem1.value = newValue;
                  colorQuery.value = newValue;
                },
                selectedItemBuilder: (context) {
                  return color1.map((item) {
                    return Text(
                      item.key,
                      style: TextStyle(color: item.value),
                    );
                  }).toList();
                },
                items: color1.map((item) {
                  return DropdownMenuItem(
                    value: item.key,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Neumorphic(
                        style: NeumorphicStyle(
                            color: bgColor,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              item.key,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(
                              Icons.waves,
                              color: item.value,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

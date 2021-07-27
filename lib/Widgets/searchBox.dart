// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

// Project imports:
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import '../Store/Search.dart';

class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(
        color: bgColor,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8.0, left: 8, right: 8, bottom: 20),
          child: InkWell(
            onTap: () {
              Route route = MaterialPageRoute(
                fullscreenDialog: true,
                builder: (c) => SearchProduct(),
              );
              Navigator.push(
                context,
                route,
              );
            },
            child: Neumorphic(
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
              style: NeumorphicStyle(
                  depth: NeumorphicTheme.embossDepth(context),
                  boxShape: NeumorphicBoxShape.stadium(),
                  color: bgColor),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 18),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8,
                      ),
                      child: Text("探す"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  @override
  double get maxExtent => 75;

  @override
  double get minExtent => 75;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

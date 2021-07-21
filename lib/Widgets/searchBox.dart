// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import '../Store/Search.dart';

class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(
        color: HexColor("#E67928"),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8.0, left: 8, right: 8, bottom: 20),
          child: InkWell(
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (c) => SearchProduct(),
              );
              Navigator.push(
                context,
                route,
              );
            },
            child: Container(
              // width: MediaQuery.of(
              //   context,
              // ).size.width,
              height: 80,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(0.2),
                      blurRadius: 8.0,
                      spreadRadius: 1.0,
                      offset: Offset(5, 8))
                ],
                color: HexColor("F9DAC4"),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
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
      );

  @override
  double get maxExtent => 75;

  @override
  double get minExtent => 75;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

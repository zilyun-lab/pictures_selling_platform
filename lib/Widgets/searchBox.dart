import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              const EdgeInsets.only(top: 8.0, left: 8, right: 8, bottom: 45),
          child: InkWell(
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (c) => SearchProduct(),
              );
              Navigator.pushReplacement(
                context,
                route,
              );
            },
            child: InkWell(
              child: Container(
                width: MediaQuery.of(
                  context,
                ).size.width,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8,
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
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:selling_pictures_platform/Models/AllProviders.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LikePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var _gridCount = useState(1);
    final item = ref.watch(likeItemStreamProvider);
    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: mySizedBox(MediaQuery.of(context).size.height * 0.04),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: bgColor,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15, top: 8, bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "いいね",
                      style: GoogleFonts.kosugi(
                          color: mainColorOfLEEWAY,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          child: NeumorphicIcon(
                            Icons.crop_square,
                            size: 40,
                            style: NeumorphicStyle(
                              color: mainColorOfLEEWAY,
                            ),
                          ),
                          onTap: () {
                            _gridCount.value = 1;
                            print(_gridCount.value);
                          },
                        ),
                        InkWell(
                          child: NeumorphicIcon(
                            Icons.grid_view_outlined,
                            size: 40,
                            style: NeumorphicStyle(
                              color: mainColorOfLEEWAY,
                            ),
                          ),
                          onTap: () {
                            _gridCount.value = 2;
                            print(_gridCount.value);
                          },
                        ),
                        InkWell(
                          child: NeumorphicIcon(
                            Icons.grid_3x3_outlined,
                            size: 40,
                            style: NeumorphicStyle(
                              color: mainColorOfLEEWAY,
                            ),
                          ),
                          onTap: () {
                            _gridCount.value = 3;

                            print(_gridCount.value);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          () {
            if (_gridCount.value == 2) {
              return item.when(
                data: (items) {
                  return SliverList(
                      delegate: SliverChildListDelegate([
                    GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _gridCount.value,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return sourceInfoForMainOfLikex2(
                              item.thumbnailUrl, item.id, context);
                        })
                  ]));
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              );
            } else if (_gridCount.value == 1) {
              return item.when(
                data: (items) {
                  return SliverList(
                      delegate: SliverChildListDelegate([
                    GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _gridCount.value,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return sourceInfoForMainOfLikex1(
                              item.thumbnailUrl, item.id, context);
                        })
                  ]));
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              );
            } else {
              return item.when(
                data: (items) {
                  return SliverList(
                      delegate: SliverChildListDelegate([
                    GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _gridCount.value,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return sourceInfoForMainOfLikex3(
                              item.thumbnailUrl, item.id, context);
                        })
                  ]));
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              );
            }
          }()
        ],
      ),
    );
  }
}

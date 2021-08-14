// Flutter imports:
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Models/all_providers.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Models/allList.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'update_item.dart';

class ProductPage extends HookConsumerWidget {
  final String id;
  const ProductPage(
    this.id,
  );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(specificIDItemsStreamProvider(id));
    final itemImages =
        ref.watch(specificIDItemsImageStreamProvider(id));
    final specificItem = item.data?.value;
    final specificItemImage = itemImages.data?.value;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          title: Text(
            specificItem.first.shortInfo.toString(),
            style: TextStyle(
                color: HexColor('#E67928'), fontWeight: FontWeight.w800),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: NeumorphicButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: const NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          actions: [ReportButton(id)],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('items')
                        .doc(id)
                        .collection('itemImages')
                        .doc(id)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snapshot) {
                      return snapshot.data == null
                          ? Container()
                          : CarouselSlider.builder(
                              options: CarouselOptions(
                                height: 300,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: false,
                              ),
                              itemCount: snapshot.data.data()['images'].length,
                              itemBuilder: (BuildContext context, int index,
                                  int realIndex) {
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: HexColor('#e0e5ec'),
                                              boxShadow: [
                                                const BoxShadow(
                                                  color: Color(0xFFFFFFFF),
                                                  spreadRadius: 1,
                                                  blurRadius: 10,
                                                  offset: Offset(-5, -5),
                                                ),
                                                BoxShadow(
                                                  color: HexColor('#a3b1c6'),
                                                  spreadRadius: 1,
                                                  blurRadius: 12,
                                                  offset: const Offset(2, 2),
                                                ),
                                              ]),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: HexColor('#e0e5ec'),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          HexColor('#a3b1c6'),
                                                      spreadRadius: 1,
                                                      blurRadius: 12,
                                                      offset: const Offset(3, 3),
                                                    ),
                                                    BoxShadow(
                                                      color:
                                                          HexColor('#ffffff'),
                                                      spreadRadius: 1,
                                                      blurRadius: 10,
                                                      offset: const Offset(-3, -3),
                                                    ),
                                                  ]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(30),
                                                child: Image.network(
                                                  snapshot.data
                                                      .data()['images'][index]
                                                      .toString(),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        'LEEWAY',
                                        style: GoogleFonts.notoSerif(
                                            fontWeight: FontWeight.w100,
                                            color: Colors.grey.withOpacity(0.6),
                                            fontSize: 50),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                    })),
            mySizedBox(20),
            Neumorphic(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 1),
              style: NeumorphicStyle(
                shadowDarkColorEmboss: Colors.black.withOpacity(0.6),
                shadowLightColorEmboss: Colors.black.withOpacity(0.4),
                color: bgColor,
                intensity: 1,
                depth: -4,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          specificItem.first.shortInfo ?? '',
                          style: largeTextStyle,
                        ),
                        specificItem.first.Stock == 0
                            ? Container()
                            : likeButton(context, id)
                      ],
                    ),
                    Text(
                      specificItem.first.longDescription ?? '',
                      style: boldTextStyle,
                    ),
                    (() {
                      if (specificItem.first.attribute == 'Original') {
                        return const Text(
                          'こちらは原画の為、１点限りとなります。',
                          style: boldTextStyle,
                        );
                      } else if (specificItem.first.attribute == 'Sticker') {
                        return const Text(
                          'ステッカー',
                          style: boldTextStyle,
                        );
                      } else if (specificItem.first.attribute == 'PostCard') {
                        return const Text(
                          'ポストカード',
                          style: boldTextStyle,
                        );
                      } else {
                        return const Text(
                          '複製画',
                          style: boldTextStyle,
                        );
                      }
                    }()),
                    specificItem.first.attribute != 'PostCard'
                        ? Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: specificItem.first.itemHeight,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                    const TextSpan(
                                      text: 'mm',
                                    ),
                                  ],
                                ),
                              ),
                              const Text(' x ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: specificItem.first.itemWidth,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                    const TextSpan(
                                      text: 'mm',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              const Text('郵便ハガキサイズ(', style: boldTextStyle),
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '148',
                                      style: boldTextStyle,
                                    ),
                                    TextSpan(
                                      text: 'mm',
                                    ),
                                  ],
                                ),
                              ),
                              const Text(' x ', style: boldTextStyle),
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '100',
                                      style: boldTextStyle,
                                    ),
                                    TextSpan(
                                      text: 'mm',
                                    ),
                                  ],
                                ),
                              ),
                              const Text(')', style: boldTextStyle),
                            ],
                          ),
                    () {
                      if (specificItem.first.Stock == null) {
                        return const Text(
                          'こちらの商品は受注生産でございます。',
                          style: boldTextStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                        );
                      } else if (specificItem.first.Stock <= 0) {
                        return const Text(
                          'SOLD OUT',
                          style: boldTextStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                        );
                      } else {
                        return RichText(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          text: TextSpan(
                            style: boldTextStyle,
                            children: [
                              TextSpan(
                                text: specificItem.first.Stock.toString(),
                              ),
                              const TextSpan(
                                text: ' 点',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }(),
                    Text(
                      specificItem.first.shipsDate,
                      style: boldTextStyle,
                    ),
                    Text(
                      specificItem.first.shipsPayment ?? '',
                      style: boldTextStyle,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      text: TextSpan(
                        style: boldTextStyle,
                        children: [
                          TextSpan(
                            text: specificItem.first.price.toString(),
                          ),
                          const TextSpan(
                            text: '円',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // userLink(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection(
                                'items',
                              )
                              .snapshots(),
                          builder: (context, snapshot) {
                            return !snapshot.hasData
                                ? Container()
                                : specificItem.first.postBy ==
                                        EcommerceApp.sharedPreferences
                                            .getString(EcommerceApp.userUID)
                                    ? ItemEditButton(id)
                                    //todo　後で直す
                                    : specificItem.first.Stock <= 0
                                        ? soldOutButton(context)
                                        : checkOutItemButton(context, id);
                          },
                        ),
                        specificItem.first.postBy ==
                                EcommerceApp.sharedPreferences
                                    .getString(EcommerceApp.userUID)
                            ? deleteItemButton(context, () {
                                beforeDeleteDialog(
                                    context, specificItem.first.shortInfo, id);
                              })
                            : Container()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemEditButton extends HookConsumerWidget {
  final String id;
  const ItemEditButton(this.id);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(specificIDItemsStreamProvider(id));
    final specificItem = item.data?.value;
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            height: 60,
            width: 260,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: HexColor('2997E5')),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => UpdateItemInfo(
                            shortInfo: specificItem.first.shortInfo,
                            id: id,
                            longDescription: specificItem.first.longDescription,
                            price: specificItem.first.price,
                            attribute: specificItem.first.attribute)));
              },
              label: const Text(
                '編集する',
                style: TextStyle(fontSize: 20),
              ),
              icon: const Icon(Icons.edit),
            ),
          ),
        ),
      ),
    );
  }
}

class ReportButton extends HookWidget {
  final String id;
  const ReportButton(
    this.id,
  );
  @override
  Widget build(BuildContext context) {
    final _verticalGroupValue = useState('');
    return Padding(
      padding: const EdgeInsets.all(8),
      child: NeumorphicButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (c) {
                  return Container(
                    height: 200,
                    child: AlertDialog(
                      title: const Center(
                        child: Text(
                          '通報',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      content: RadioButtonGroup(
                        labels: reportTitle,
                        onSelected: (String selected) {
                          _verticalGroupValue.value = selected;

                          print(_verticalGroupValue);
                        },
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.transparent),
                                  child: const Text('キャンセル'),
                                ),
                              ),
                            ),
                            _verticalGroupValue.value == ''
                                ? Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.transparent),
                                        child: const Text(
                                          '送信する',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('report')
                                              .doc()
                                              .set({
                                            'reportFrom': EcommerceApp
                                                .sharedPreferences
                                                .getString(
                                                    EcommerceApp.userUID),
                                            'date': DateTime.now(),
                                            'reportTo': id,
                                            'why': _verticalGroupValue,
                                            'Tag': 'ItemReport'
                                          });
                                        },
                                        child: const Text(
                                          '送信',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          },
          style: const NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.circle(),
          ),
          child: const Icon(
            Icons.more_horiz,
            color: Colors.grey,
            size: 30,
          )),
    );
  }
}

// class ProductPage extends StatefulWidget {
//   final String id;
//
//   ProductPage({
//     this.id,
//   });
//   @override
//   _ProductPageState createState() => _ProductPageState();
// }
//
// class _ProductPageState extends State<ProductPage> {
//   String _verticalGroupValue = '';
//
//   _ProductPageState();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getItemData();
//   }
//
//   Map<String, dynamic> il = {};
//
//   void getItemData() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('items')
//         .doc(widget.id)
//         .get();
//
//     setState(() {
//       il = snapshot.data();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(70),
//         child: AppBar(
//           backgroundColor: bgColor,
//           elevation: 0,
//           title: Text(
//             il['shortInfo'] ?? '',
//             style: TextStyle(
//                 color: HexColor('#E67928'), fontWeight: FontWeight.w800),
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//           ),
//           leading: Padding(
//             padding: const EdgeInsets.all(8),
//             child: NeumorphicButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               style: NeumorphicStyle(
//                 shape: NeumorphicShape.flat,
//                 boxShape: NeumorphicBoxShape.circle(),
//               ),
//               padding: const EdgeInsets.all(8),
//               child: Icon(
//                 Icons.arrow_back,
//               ),
//             ),
//           ),
//           actions: [reportButton()],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Center(
//                 child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                     stream: FirebaseFirestore.instance
//                         .collection('items')
//                         .doc(widget.id)
//                         .collection('itemImages')
//                         .doc(widget.id)
//                         .snapshots(),
//                     builder: (context,
//                         AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
//                             snapshot) {
//                       return snapshot.data == null
//                           ? Container()
//                           : CarouselSlider.builder(
//                               options: CarouselOptions(
//                                 height: 300,
//                                 enlargeCenterPage: true,
//                                 enableInfiniteScroll: false,
//                               ),
//                               itemCount: snapshot.data.data()['images'].length,
//                               itemBuilder: (BuildContext context, int index,
//                                   int realIndex) {
//                                 return Stack(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(8),
//                                       child: Center(
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               color: HexColor('#e0e5ec'),
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: Color(0xFFFFFFFF),
//                                                   spreadRadius: 1,
//                                                   blurRadius: 10,
//                                                   offset: Offset(-5, -5),
//                                                 ),
//                                                 BoxShadow(
//                                                   color: HexColor('#a3b1c6'),
//                                                   spreadRadius: 1,
//                                                   blurRadius: 12,
//                                                   offset: Offset(2, 2),
//                                                 ),
//                                               ]),
//                                           child: Container(
//                                               decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(8),
//                                                   color: HexColor('#e0e5ec'),
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color:
//                                                           HexColor('#a3b1c6'),
//                                                       spreadRadius: 1,
//                                                       blurRadius: 12,
//                                                       offset: Offset(3, 3),
//                                                     ),
//                                                     BoxShadow(
//                                                       color:
//                                                           HexColor('#ffffff'),
//                                                       spreadRadius: 1,
//                                                       blurRadius: 10,
//                                                       offset: Offset(-3, -3),
//                                                     ),
//                                                   ]),
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(30),
//                                                 child: Image.network(
//                                                   snapshot.data
//                                                       .data()['images'][index]
//                                                       .toString(),
//                                                 ),
//                                               )),
//                                         ),
//                                       ),
//                                     ),
//                                     Center(
//                                       child: Text(
//                                         'LEEWAY',
//                                         style: GoogleFonts.notoSerif(
//                                             fontWeight: FontWeight.w100,
//                                             color: Colors.grey.withOpacity(0.6),
//                                             fontSize: 50),
//                                       ),
//                                     )
//                                   ],
//                                 );
//                               },
//                             );
//                     })),
//             mySizedBox(20),
//             Neumorphic(
//               margin: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 1),
//               style: NeumorphicStyle(
//                 shadowDarkColorEmboss: Colors.black.withOpacity(0.6),
//                 shadowLightColorEmboss: Colors.black.withOpacity(0.4),
//                 color: bgColor,
//                 intensity: 1,
//                 depth: -4,
//                 boxShape:
//                     NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
//               ),
//               padding: EdgeInsets.symmetric(vertical: 2, horizontal: 18),
//               child: Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           il['shortInfo'] ?? '',
//                           style: largeTextStyle,
//                         ),
//                         il['Stock'] == 0 ? Container() : likeButton(context, il)
//                       ],
//                     ),
//                     Text(
//                       il['longDescription'] ?? '',
//                       style: boldTextStyle,
//                     ),
//                     (() {
//                       if (il['attribute'] == 'Original') {
//                         return Text(
//                           'こちらは原画の為、１点限りとなります。',
//                           style: boldTextStyle,
//                         );
//                       } else if (il['attribute'] == 'Sticker') {
//                         return Text(
//                           'ステッカー',
//                           style: boldTextStyle,
//                         );
//                       } else if (il['attribute'] == 'PostCard') {
//                         return Text(
//                           'ポストカード',
//                           style: boldTextStyle,
//                         );
//                       } else {
//                         return Text(
//                           '複製画',
//                           style: boldTextStyle,
//                         );
//                       }
//                     }()),
//                     il['attribute'] != 'PostCard'
//                         ? Row(
//                             children: [
//                               RichText(
//                                 text: TextSpan(
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text: il['itemHeight'],
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 20),
//                                     ),
//                                     TextSpan(
//                                       text: 'mm',
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Text(' x ',
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 15)),
//                               RichText(
//                                 text: TextSpan(
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text: il['itemWidth'],
//                                       style: TextStyle(
//                                           color: Colors.black, fontSize: 20),
//                                     ),
//                                     TextSpan(
//                                       text: 'mm',
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           )
//                         : Row(
//                             children: [
//                               Text('郵便ハガキサイズ(', style: boldTextStyle),
//                               RichText(
//                                 text: TextSpan(
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text: '148',
//                                       style: boldTextStyle,
//                                     ),
//                                     TextSpan(
//                                       text: 'mm',
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Text(' x ', style: boldTextStyle),
//                               RichText(
//                                 text: TextSpan(
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                   ),
//                                   children: [
//                                     TextSpan(
//                                       text: '100',
//                                       style: boldTextStyle,
//                                     ),
//                                     TextSpan(
//                                       text: 'mm',
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Text(')', style: boldTextStyle),
//                             ],
//                           ),
//                     () {
//                       if (il['Stock'] == null) {
//                         return Text(
//                           'こちらの商品は受注生産でございます。',
//                           style: boldTextStyle,
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 10,
//                         );
//                       } else if (il['Stock'] <= 0) {
//                         return Text(
//                           'SOLD OUT',
//                           style: boldTextStyle,
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 10,
//                         );
//                       } else {
//                         return RichText(
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                           text: TextSpan(
//                             style: boldTextStyle,
//                             children: [
//                               TextSpan(
//                                 text: il['Stock'].toString(),
//                               ),
//                               TextSpan(
//                                 text: ' 点',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }
//                     }(),
//                     Text(
//                       '${il['shipsDate']}',
//                       style: boldTextStyle,
//                     ),
//                     Text(
//                       il['shipsPayment'] ?? '',
//                       style: boldTextStyle,
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     RichText(
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                       text: TextSpan(
//                         style: boldTextStyle,
//                         children: [
//                           TextSpan(
//                             text: il['price'].toString(),
//                           ),
//                           TextSpan(
//                             text: '円',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     userLink(il),
//                     Row(
//                       children: [
//                         StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                           stream: FirebaseFirestore.instance
//                               .collection(
//                                 'items',
//                               )
//                               .snapshots(),
//                           builder: (context, snapshot) {
//                             return !snapshot.hasData
//                                 ? Container()
//                                 : il['postBy'] ==
//                                         EcommerceApp.sharedPreferences
//                                             .getString(EcommerceApp.userUID)
//                                     ? itemEditButton(context, il, widget.id)
//                                     //todo　後で直す
//                                     : il['Stock'] <= 0
//                                         ? soldOutButton(context)
//                                         : checkOutItemButton(
//                                             context, il, widget.id);
//                           },
//                         ),
//                         il['postBy'] ==
//                                 EcommerceApp.sharedPreferences
//                                     .getString(EcommerceApp.userUID)
//                             ? deleteItemButton(context, () {
//                                 beforeDeleteDialog(context, il, widget.id);
//                               })
//                             : Container()
//                       ],
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

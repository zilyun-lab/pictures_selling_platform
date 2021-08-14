// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:selling_pictures_platform/Models/all_providers.dart';
// Project imports:
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';
import 'package:selling_pictures_platform/Widgets/AllWidget.dart';
import 'package:selling_pictures_platform/Widgets/search_box.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StoreHome extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _controller = useTabController(initialLength: 5);
    final _index = useState(0);

    _controller.addListener(() {
      _index.value = _controller.index;
    });
    final alls = ref.watch(allMainItemsStreamProvider);
    final original = ref.watch(originalItemsStreamProvider);
    final copy = ref.watch(copyItemsStreamProvider);
    final sticker = ref.watch(stickerItemsStreamProvider);
    final postcard = ref.watch(postCardItemsStreamProvider);
    return Scaffold(
      //key: //_scaffoldKey,
      // backgroundColor: mainColor,
      backgroundColor: HexColor('#e0e5ec'),
      body: Container(
        color: HexColor('#e0e5ec'),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              delegate: SearchBoxDelegate(),
              pinned: false,
            ),
            SliverToBoxAdapter(
              child: mainSlider(),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: TabBar(
                  onTap: (index) {},
                  isScrollable: true,
                  enableFeedback: false,
                  labelStyle:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  unselectedLabelColor: Colors.grey,
                  labelColor: mainColorOfLEEWAY,
                  tabs: <Widget>[
                    const Tab(text: 'すべて'),
                    const Tab(text: '原画作品'),
                    const Tab(text: '複製作品'),
                    const Tab(text: 'ステッカー'),
                    const Tab(text: 'ポストカード'),
                  ],
                  controller: _controller,
                ),
              ),
            ),
            SliverFillRemaining(
              child: Container(
                color: HexColor('#e0e5ec'),
                child: TabBarView(
                  controller: _controller,
                  children: [
                    alls.when(
                      data: (items) {
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return item.Stock == 0
                                  ? stockZeroGridItems(
                                      context,
                                      item.thumbnailUrl,
                                      item.shortInfo,
                                      item.price.toString(),
                                      item.id)
                                  : gridItems(
                                      context,
                                      item.thumbnailUrl,
                                      item.shortInfo,
                                      item.price.toString(),
                                      item.id);
                            });
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Text('Error: $error'),
                    ),
                    original.when(
                      data: (items) {
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return item.Stock == 0
                                  ? stockZeroGridItems(
                                      context,
                                      item.thumbnailUrl,
                                      item.shortInfo,
                                      item.price.toString(),
                                      item.id)
                                  : gridItems(
                                      context,
                                      item.thumbnailUrl,
                                      item.shortInfo,
                                      item.price.toString(),
                                      item.id);
                            });
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Text('Error: $error'),
                    ),
                    copy.when(
                      data: (items) {
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return item.Stock == 0
                                  ? stockZeroGridItems(
                                      context,
                                      item.thumbnailUrl,
                                      item.shortInfo,
                                      item.price.toString(),
                                      item.id)
                                  : gridItems(
                                      context,
                                      item.thumbnailUrl,
                                      item.shortInfo,
                                      item.price.toString(),
                                      item.id);
                            });
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Text('Error: $error'),
                    ),
                    sticker.when(
                      data: (items) {
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return item.Stock == 0
                                  ? stockZeroGridItems(
                                      context,
                                      item.thumbnailUrl,
                                      item.shortInfo,
                                      item.price.toString(),
                                      item.id)
                                  : gridItems(
                                      context,
                                      item.thumbnailUrl,
                                      item.shortInfo,
                                      item.price.toString(),
                                      item.id);
                            });
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Text('Error: $error'),
                    ),
                    postcard.when(
                      data: (items) {
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return item.Stock == 0
                                  ? stockZeroGridItems(
                                      context,
                                      item.thumbnailUrl,
                                      item.shortInfo,
                                      item.price.toString(),
                                      item.id)
                                  : gridItems(
                                      context,
                                      item.thumbnailUrl,
                                      item.shortInfo,
                                      item.price.toString(),
                                      item.id);
                            });
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Text('Error: $error'),
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

// class StoreHome extends StatefulWidget {
//   @override
//   _StoreHomeState createState() => _StoreHomeState();
// }
//
// class _StoreHomeState extends State<StoreHome>
//     with SingleTickerProviderStateMixin {
//   TabController _tabcontroller;
//
//   @override
//   void initState() {
//
//
//     // initAd();
//     _tabcontroller = TabController(length: 5, vsync: this);
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage message) {
//       if (message != null) {
//         Navigator.pushNamed(context, '/message',
//             arguments: MessageArguments(message, openedApplication: true));
//       }
//     });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       final notification = message.notification;
//       final android = message.notification?.android;
//
//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 channel.description,
//                 // ignore: flutter_style_todos
//                 // TODO add a proper drawable resource to android, for now using
//                 //      one that already exists in example app.
//                 icon: 'launch_background',
//               ),
//             ));
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('新規メッセージイベントがありました。');
//       Navigator.pushNamed(context, '/message',
//           arguments: MessageArguments(message, openedApplication: true));
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//
//
// }

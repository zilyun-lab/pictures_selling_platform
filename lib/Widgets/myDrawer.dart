import 'package:selling_pictures_platform/Admin/uploadItems.dart';
import 'package:selling_pictures_platform/Authentication/MyPage.dart';
import 'package:selling_pictures_platform/Authentication/authenication.dart';
import 'package:selling_pictures_platform/Config/config.dart';
import 'package:selling_pictures_platform/Address/addAddress.dart';
import 'package:selling_pictures_platform/Store/Search.dart';
import 'package:selling_pictures_platform/Store/providerGrid.dart';
import 'package:selling_pictures_platform/Store/cart.dart';
import 'package:selling_pictures_platform/Orders/myOrders.dart';
import 'package:selling_pictures_platform/Store/like.dart';
import 'package:selling_pictures_platform/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 10,
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      (80),
                    ),
                  ),
                  elevation: 8,
                  child: Container(
                    height: 160,
                    width: 160,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        EcommerceApp.sharedPreferences.getString(
                          EcommerceApp.userAvatarUrl,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userName),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                  ),
                  // fontFamily: "Signatra"),
                ),
                SizedBox(
                  height: 3,
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 1,
                  ),

                  //todo:以下ハンバーガーメニューの内容
                  child: Column(
                    children: [
                      // ListTile(
                      //   leading: Icon(
                      //     Icons.money,
                      //     color: Colors.black,
                      //   ),
                      //   title: Text(
                      //     "Stripe",
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     Route route = MaterialPageRoute(
                      //       builder: (c) => StripeCheckOut(),
                      //     );
                      //     Navigator.pushReplacement(
                      //       context,
                      //       route,
                      //     );
                      //   },
                      // ),
                      // Divider(
                      //   height: 10,
                      //   color: Colors.black,
                      //   thickness: 4,
                      // ),
                      ListTile(
                        leading: Icon(
                          Icons.perm_identity,
                          color: Colors.black,
                        ),
                        title: Text(
                          "マイページ",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          Route route = MaterialPageRoute(
                            builder: (c) => MyPage(),
                          );
                          Navigator.pushReplacement(
                            context,
                            route,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Divider(
                          height: 10,
                          color: Colors.black,
                          thickness: 4,
                        ),
                      ),
                      // ListTile(
                      //   leading: Icon(
                      //     Icons.home_outlined,
                      //     color: Colors.black,
                      //   ),
                      //   title: Text(
                      //     "ホーム",
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     Route route = MaterialPageRoute(
                      //       builder: (c) => StoreHome(),
                      //     );
                      //     Navigator.pushReplacement(
                      //       context,
                      //       route,
                      //     );
                      //   },
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 8.0, right: 8),
                      //   child: Divider(
                      //     height: 10,
                      //     color: Colors.black,
                      //     thickness: 4,
                      //   ),
                      // ),
                      ListTile(
                        leading: Icon(
                          Icons.history_sharp,
                          color: Colors.black,
                        ),
                        title: Text(
                          "注文履歴",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          Route route = MaterialPageRoute(
                            builder: (c) => MyOrders(),
                          );
                          Navigator.pushReplacement(
                            context,
                            route,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Divider(
                          height: 10,
                          color: Colors.black,
                          thickness: 4,
                        ),
                      ),
                      // ListTile(
                      //   leading: Icon(
                      //     Icons.shopping_cart_outlined,
                      //     color: Colors.black,
                      //   ),
                      //   title: Text(
                      //     "マイカート",
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     Route route = MaterialPageRoute(
                      //       builder: (c) => CartPage(),
                      //     );
                      //     Navigator.pushReplacement(
                      //       context,
                      //       route,
                      //     );
                      //   },
                      // ),
                      // Divider(
                      //   height: 10,
                      //   color: Colors.black,
                      //   thickness: 4,
                      // ),
                      ListTile(
                        leading: Icon(
                          Icons.favorite_border,
                          color: Colors.black,
                        ),
                        title: Text(
                          "いいねした作品",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          Route route = MaterialPageRoute(
                            builder: (c) => LikePage(),
                          );
                          Navigator.pushReplacement(
                            context,
                            route,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Divider(
                          height: 10,
                          color: Colors.black,
                          thickness: 4,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.search_outlined,
                          color: Colors.black,
                        ),
                        title: Text(
                          "探す",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          Route route = MaterialPageRoute(
                            builder: (c) => SearchProduct(),
                          );
                          Navigator.pushReplacement(
                            context,
                            route,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Divider(
                          height: 10,
                          color: Colors.black,
                          thickness: 4,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.add_location_alt_outlined,
                          color: Colors.black,
                        ),
                        title: Text(
                          "お届け先の追加",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          Route route = MaterialPageRoute(
                            builder: (c) => AddAddress(),
                          );
                          Navigator.pushReplacement(
                            context,
                            route,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Divider(
                          height: 10,
                          color: Colors.black,
                          thickness: 4,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        title: Text(
                          "ログアウト",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          EcommerceApp.auth.signOut().then(
                            (c) {
                              Route route = MaterialPageRoute(
                                builder: (c) => AuthenticScreen(),
                              );
                              Navigator.pushReplacement(
                                context,
                                route,
                              );
                            },
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Divider(
                          height: 10,
                          color: Colors.black,
                          thickness: 4,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.black,
                        ),
                        title: Text(
                          "出品する",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onTap: () {
                          EcommerceApp.auth.signOut().then(
                            (c) {
                              Route route = MaterialPageRoute(
                                builder: (c) => UploadPage(),
                              );
                              Navigator.pushReplacement(
                                context,
                                route,
                              );
                            },
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Divider(
                          height: 10,
                          color: Colors.black,
                          thickness: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

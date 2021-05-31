import 'package:flutter/foundation.dart';
import 'package:selling_pictures_platform/Config/config.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter = EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .length -
      1;
  int get count => _counter;

  Future<void> displayResult() async {
    int _counter = EcommerceApp.sharedPreferences
            .getStringList(EcommerceApp.userCartList)
            .length -
        1;
    await Future.delayed(
      const Duration(milliseconds: 100),
      () {
        notifyListeners();
      },
    );
  }
}

class LikeItemCounter extends ChangeNotifier {
  int counter = EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userLikeList)
          .length -
      1;
  int get count => counter;

  Future<void> displayResult() async {
    int counter = EcommerceApp.sharedPreferences
            .getStringList(EcommerceApp.userLikeList)
            .length -
        1;
    await Future.delayed(
      const Duration(milliseconds: 100),
      () {
        notifyListeners();
      },
    );
  }
}

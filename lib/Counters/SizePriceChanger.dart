import 'package:flutter/foundation.dart';

class SizePriceChanger extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  displayResult(int v) {
    _counter = v;
    notifyListeners();
  }
}

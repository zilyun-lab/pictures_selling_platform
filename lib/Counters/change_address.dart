// Flutter imports:
import 'package:flutter/foundation.dart';

class AddressChanger extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  dynamic displayResult(int v) {
    _counter = v;
    notifyListeners();
  }
}

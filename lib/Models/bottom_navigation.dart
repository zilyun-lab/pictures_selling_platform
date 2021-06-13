import 'package:flutter/cupertino.dart';

class BottomNavigationEntity {
  String title;
  IconData icon;
  Widget page;
  BottomNavigationEntity({this.page, this.title, this.icon});
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageRoute {
  var page;
  var context;
  PageRoute(this.page, this.context);
  route() {
    final route = MaterialPageRoute(
      builder: (c) => page,
    );
    return Navigator.pushReplacement(context, route);
  }
}

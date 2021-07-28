import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';

class NeumoTest extends StatelessWidget {
  const NeumoTest({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#e0e5ec"),
      //backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: HexColor("#e0e5ec"),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFFFFFF),
                      spreadRadius: 1.0,
                      blurRadius: 10.0,
                      offset: Offset(-5, -5),
                    ),
                    BoxShadow(
                      color: HexColor("#a3b1c6"),
                      spreadRadius: 1.0,
                      blurRadius: 12.0,
                      offset: Offset(2, 2),
                    ),
                  ]),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: HexColor("#e0e5ec"),
                      boxShadow: [
                        BoxShadow(
                          color: HexColor("#a3b1c6"),
                          spreadRadius: 1.0,
                          blurRadius: 12.0,
                          offset: Offset(3, 3),
                        ),
                        BoxShadow(
                          color: HexColor("#ffffff"),
                          spreadRadius: 1.0,
                          blurRadius: 10.0,
                          offset: Offset(-3, -3),
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Image.asset("images/NoColor_Vertical.png"),
                  )),
            ),

            // Container(
            //   height: 100,
            //   width: 100,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(8),
            //       color: HexColor("#e0e5ec"),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Color(0xFFFFFFFF),
            //           spreadRadius: 1.0,
            //           blurRadius: 10.0,
            //           offset: Offset(-5, -5),
            //         ),
            //         BoxShadow(
            //           color: HexColor("#a3b1c6"),
            //           spreadRadius: 1.0,
            //           blurRadius: 12.0,
            //           offset: Offset(2, 2),
            //         ),
            //       ]),
            //   child: Container(
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(8),
            //           color: HexColor("#e0e5ec"),
            //           boxShadow: [
            //             BoxShadow(
            //               color: HexColor("#a3b1c6"),
            //               spreadRadius: 1.0,
            //               blurRadius: 12.0,
            //               offset: Offset(3, 3),
            //             ),
            //             BoxShadow(
            //               color: HexColor("#ffffff"),
            //               spreadRadius: 1.0,
            //               blurRadius: 10.0,
            //               offset: Offset(-3, -3),
            //             ),
            //           ]),
            //       child: Padding(
            //         padding: const EdgeInsets.all(30.0),
            //         child: Image.asset("images/isColor_Vertical.png"),
            //       )),
            // ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:selling_pictures_platform/Models/HEXCOLOR.dart';

class NeumoTest extends StatelessWidget {
  const NeumoTest({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: NeumorphicFloatingActionButton(
        child: Icon(Icons.add, size: 30),
        onPressed: () {},
      ),
      backgroundColor: HexColor("#e0e5ec"),
      //backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NeumorphicButton(
              onPressed: () {
                print("onClick");
              },
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),
            ),
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
            SizedBox(
              height: 30,
            ),
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
                    child: Image.asset("images/isColor_Vertical.png"),
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
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
                    borderRadius: BorderRadius.circular(50),
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
                  child: Icon(
                    Icons.favorite,
                    color: HexColor("e67928"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

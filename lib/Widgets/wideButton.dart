import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  final String message;
  final Function onPressed;

  WideButton({Key key, this.message, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.75)),
          width: MediaQuery.of(context).size.width * 0.85,
          height: 50,
          child: Center(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

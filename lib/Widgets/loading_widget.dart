// Flutter imports:
import 'package:flutter/material.dart';

Container circular_progress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(
      top: 12,
    ),
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Colors.black,
      ),
    ),
  );
}

Container linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(
      top: 12,
    ),
    child: const LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Colors.amberAccent,
      ),
    ),
  );
}

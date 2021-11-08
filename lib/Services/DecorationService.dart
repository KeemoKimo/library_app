import 'package:flutter/cupertino.dart';

class DecorationService {
  //!Function for making gradient for container
  static LinearGradient gradientColor(var sPos, ePos, Color c1, c2, c3, c4) {
    return LinearGradient(
      begin: sPos,
      end: ePos,
      colors: [c1, c2, c3, c4],
    );
  }
}

import 'dart:ui';

import 'package:flutter/widgets.dart';

class ScratchData extends ChangeNotifier {
  List<Offset> points = [];

  void addPoint(Offset offset) {
    points.add(offset);
    notifyListeners();
  }
}
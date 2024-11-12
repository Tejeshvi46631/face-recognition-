import 'package:flutter/material.dart';

class FaceBoundingBoxProvider extends ChangeNotifier {
  Rect? _boundingBox;

  Rect? get boundingBox => _boundingBox;

  void setBoundingBox(Rect boundingBox) {
    _boundingBox = boundingBox;
    notifyListeners();
  }
}

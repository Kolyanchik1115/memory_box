import 'package:flutter/material.dart';

class OverlayPlayer {
  static OverlayEntry? overlayEntry;
  static bool showDraggableFloat = false;

  static removePreviousOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
    overlayEntry?.dispose();
  }
}

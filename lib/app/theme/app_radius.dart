import 'package:flutter/material.dart';

/// Border radius scale extracted from the Clinigoo design system.
abstract final class AppRadius {
  static const BorderRadius xs = BorderRadius.all(Radius.circular(8));
  static const BorderRadius sm = BorderRadius.all(Radius.circular(12));
  static const BorderRadius md = BorderRadius.all(Radius.circular(16));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(20));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(28));
  static const BorderRadius full = BorderRadius.all(Radius.circular(1000));

  static const double xsValue = 8;
  static const double smValue = 12;
  static const double mdValue = 16;
  static const double lgValue = 20;
  static const double xlValue = 28;
}

/// Shadow scale used for elevated surfaces and cards.
abstract final class AppShadows {
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x0A0B1C30),
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
  ];
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0D0B1C30),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];
  static const List<BoxShadow> strong = [
    BoxShadow(
      color: Color(0x1A0B1C30),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}

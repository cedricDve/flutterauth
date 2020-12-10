import 'package:flutter/cupertino.dart';

class NavbarKey {
  NavbarKey._();
  static final GlobalKey _globalKey = GlobalKey();

  static GlobalKey getKey() => _globalKey;
}

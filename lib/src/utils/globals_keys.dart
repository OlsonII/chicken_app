
import 'package:flutter/material.dart';

class GlobalsKeys {

  GlobalKey _scaffoldKey;
  GlobalKey _driversDropDownKey;

  GlobalsKeys() {
    _scaffoldKey = GlobalKey();
    _driversDropDownKey = GlobalKey();
  }

  GlobalKey get scaffoldKey => _scaffoldKey;
  GlobalKey get driversDropDownKey => _driversDropDownKey;
}

GlobalsKeys globalsKeys = new GlobalsKeys();
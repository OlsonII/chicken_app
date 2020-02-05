
import 'package:flutter/material.dart';

class GlobalsKeys {

  GlobalKey _scaffoldKey;

  GlobalsKeys() {
    _scaffoldKey = GlobalKey();
  }

  GlobalKey get scaffoldKey => _scaffoldKey;
}

GlobalsKeys globalsKeys = new GlobalsKeys();
import 'package:flutter/material.dart';

mixin SafeSetStateMixin<T extends StatefulWidget> on State<T> {
  //. Safe Set State
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}

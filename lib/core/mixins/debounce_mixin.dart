import 'dart:async';

import 'package:flutter/material.dart';

mixin DebounceMixin<T extends StatefulWidget> on State<T> {
  Timer? _debounceTimer;

  //. Debounce
  void debounce(
    VoidCallback action, {
    Duration duration = const Duration(milliseconds: 350),
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, action);
  }

  //. Dispose
  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

import 'package:flutter/material.dart';

mixin ScrollPaginationMixin<T extends StatefulWidget> on State<T> {
  late final ScrollController scrollController;

  //. Create this functions
  void onScrollNearBottom();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(_scrollListener);
  }

  //. Scroll Listner
  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      onScrollNearBottom();
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }
}

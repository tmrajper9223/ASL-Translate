import 'package:flutter/material.dart';

import 'camera_page.dart';
import 'alphabet_index_page.dart';

class PageViewManager extends StatefulWidget {
  @override
  _PageViewManagerState createState() => _PageViewManagerState();
}

class _PageViewManagerState extends State<PageViewManager> {

  PageController _pageController = PageController(
    initialPage: 1
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: <Widget>[
        AlphabetIndexPage(),
        CameraPage()
      ],
      scrollDirection: Axis.horizontal,
    );
  }
}
import "package:flutter/material.dart";

import 'LatestImage.dart';
import 'RandomPhoto.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: SafeArea(
        child: _buildPage(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff222222),
        selectedItemColor: Color(0xffffffff),
        unselectedItemColor: Color(0xff222222),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? Image.asset('assets/home.png')
                  : Image.asset('assets/home_grey.png'),
              label: 'home'),
          BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? Image.asset('assets/bookmark.png')
                  : Image.asset('assets/bookmark_grey.png'),
              label: 'bookmark'),
        ],
      ),
    );
  }
}

AppBar _appbar() {
  return AppBar(
    title: Image.asset('assets/logo.png'),
    centerTitle: true,
    toolbarHeight: 56.0,
    bottom: PreferredSize(
      child: Divider(
        height: 0.1,
        color: Color(0xffB3B3BE),
      ),
      preferredSize: Size.fromHeight(0.1),
    ),
  );
}

Widget _buildPage(int index) {
  switch (index) {
    case 0:
      return MainPhoto(); // 목록 페이지
    case 1:
      return RandomPhoto(); // 랭킹 페이지
    default:
      return MainPhoto();
  }
}

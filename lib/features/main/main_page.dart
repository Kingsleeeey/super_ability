import 'package:flutter/material.dart';
import 'package:sa_widgets/sa_widgets.dart';

import '../courses/courses_page.dart';
import '../favorite/favorite_page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import '../settings/settings_page.dart';

/// 主页面 - 包含底部 TabBar 导航。
///
/// 管理 5 个 Tab 页面的切换：主页、喜欢、课程、个人中心、设置。
class MainPage extends StatefulWidget {
  /// 创建主页面。
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  /// 5 个 Tab 页面。
  static const List<Widget> _pages = [
    HomePage(),
    FavoritePage(),
    CoursesPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  /// Tab 配置数据。
  static const List<SATabItem> _tabs = [
    SATabItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: '主页',
    ),
    SATabItem(
      icon: Icons.favorite_border,
      activeIcon: Icons.favorite,
      label: '喜欢',
    ),
    SATabItem(
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book,
      label: '课程',
    ),
    SATabItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: '个人中心',
    ),
    SATabItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: '设置',
    ),
  ];

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: SACapsuleBottomNavBar(
        tabs: _tabs,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

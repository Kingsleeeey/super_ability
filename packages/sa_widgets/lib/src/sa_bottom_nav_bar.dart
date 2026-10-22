import 'package:flutter/material.dart';

/// 底部导航栏 Tab 数据模型。
class SATabItem {
  /// 创建 Tab 数据。
  const SATabItem({required this.icon, required this.label, this.activeIcon});

  /// 未选中状态的图标。
  final IconData icon;

  /// 选中状态的图标（可选，默认为 icon）。
  final IconData? activeIcon;

  /// Tab 标签文字。
  final String label;
}

/// 通用底部导航栏组件。
///
/// 封装了底部 TabBar 的常用配置，支持自定义样式和切换回调。
class SABottomNavBar extends StatelessWidget {
  /// 创建底部导航栏。
  const SABottomNavBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.showLabels = true,
    this.type = BottomNavigationBarType.fixed,
    super.key,
  });

  /// Tab 数据列表。
  final List<SATabItem> tabs;

  /// 当前选中索引。
  final int currentIndex;

  /// 点击回调。
  final ValueChanged<int> onTap;

  /// 背景色。
  final Color? backgroundColor;

  /// 选中状态颜色。
  final Color? selectedColor;

  /// 未选中状态颜色。
  final Color? unselectedColor;

  /// 是否显示标签。
  final bool showLabels;

  /// 导航栏类型。
  final BottomNavigationBarType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: type,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      selectedItemColor: selectedColor ?? colorScheme.primary,
      unselectedItemColor: unselectedColor ?? colorScheme.onSurfaceVariant,
      showSelectedLabels: showLabels,
      showUnselectedLabels: showLabels,
      elevation: 8,
      items: tabs.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(tab.icon),
          activeIcon: Icon(tab.activeIcon ?? tab.icon),
          label: tab.label,
        );
      }).toList(),
    );
  }
}

/// 带安全区域的底部导航栏包装组件。
///
/// 自动处理底部安全区域和键盘弹出时的隐藏逻辑。
class SABottomNavBarScaffold extends StatelessWidget {
  /// 创建带底部导航栏的页面脚手架。
  const SABottomNavBarScaffold({
    required this.body,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.appBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    super.key,
  });

  /// 页面内容。
  final Widget body;

  /// Tab 数据列表。
  final List<SATabItem> tabs;

  /// 当前选中索引。
  final int currentIndex;

  /// Tab 点击回调。
  final ValueChanged<int> onTap;

  /// 顶部导航栏。
  final PreferredSizeWidget? appBar;

  /// 页面背景色。
  final Color? backgroundColor;

  /// 是否调整页面大小以避免底部遮挡。
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      bottomNavigationBar: SABottomNavBar(
        tabs: tabs,
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}

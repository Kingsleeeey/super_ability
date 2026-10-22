import 'package:flutter/material.dart';
import 'package:sa_theme/sa_theme.dart';

import 'features/main/main_page.dart';

void main() {
  runApp(const MyApp());
}

/// 应用根组件。
class MyApp extends StatelessWidget {
  /// 创建应用根组件。
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Ability',
      theme: SAAppTheme.light(),
      darkTheme: SAAppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const MainPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sa_widgets/sa_widgets.dart';

/// 首页 - 空白占位页面。
class HomePage extends StatelessWidget {
  /// 创建首页。
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SAAppBar(
        title: '首页',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '首页',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

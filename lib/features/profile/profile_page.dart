import 'package:flutter/material.dart';
import 'package:sa_widgets/sa_widgets.dart';

/// 我的页 - 空白占位页面。
class ProfilePage extends StatelessWidget {
  /// 创建我的页。
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SAAppBar(
        title: '我的',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '我的',
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

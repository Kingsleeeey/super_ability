import 'package:flutter/material.dart';
import 'package:sa_widgets/sa_widgets.dart';

/// 课程页 - 空白占位页面。
class CoursesPage extends StatelessWidget {
  /// 创建课程页。
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SAAppBar(
        title: '课程',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '课程',
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

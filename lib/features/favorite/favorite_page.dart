import 'package:flutter/material.dart';
import 'package:sa_widgets/sa_widgets.dart';

/// 喜欢页 - 空白占位页面。
class FavoritePage extends StatelessWidget {
  /// 创建喜欢页。
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SAAppBar(
        title: '喜欢',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '喜欢',
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

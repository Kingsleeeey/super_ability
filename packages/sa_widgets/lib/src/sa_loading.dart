import 'package:flutter/material.dart';

/// 通用加载指示器。
class SALoading extends StatelessWidget {
  /// 创建一个居中加载指示器。
  const SALoading({this.message, this.size = 36, super.key});

  /// 加载提示文字。
  final String? message;

  /// 指示器尺寸。
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(strokeWidth: 2.5),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

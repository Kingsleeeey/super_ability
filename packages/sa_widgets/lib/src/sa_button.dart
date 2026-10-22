import 'package:flutter/material.dart';

/// 通用按钮组件。
class SAButton extends StatelessWidget {
  /// 创建一个主按钮。
  const SAButton({
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.isDisabled = false,
    super.key,
  });

  /// 创建一个文字按钮。
  SAButton.text({
    required VoidCallback? onPressed,
    required String text,
    Color? textColor,
    super.key,
  }) : onPressed = onPressed,
       isLoading = false,
       isDisabled = onPressed == null,
       child = Text(
         text,
         style: TextStyle(
           color: textColor ?? Colors.white,
           fontSize: 14,
           fontWeight: FontWeight.w500,
         ),
       );

  /// 点击回调。
  final VoidCallback? onPressed;

  /// 按钮内容。
  final Widget child;

  /// 是否处于加载状态。
  final bool isLoading;

  /// 是否禁用。
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        disabledBackgroundColor: theme.colorScheme.primary.withValues(
          alpha: 0.38,
        ),
        disabledForegroundColor: theme.colorScheme.onPrimary.withValues(
          alpha: 0.38,
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sa_theme/sa_theme.dart';

/// 通用应用导航栏组件。
///
/// 封装了常用的导航栏配置，支持标题、返回按钮、操作按钮等。
/// 默认使用主题配色，可通过参数自定义。
class SAAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// 创建一个标准导航栏。
  const SAAppBar({
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.bottom,
    super.key,
  });

  /// 创建一个带返回按钮的导航栏。
  SAAppBar.withBack({
    required BuildContext context,
    this.title,
    this.titleWidget,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.bottom,
    super.key,
  }) : leading = IconButton(
         icon: const Icon(Icons.arrow_back_ios_rounded),
         onPressed: () => Navigator.of(context).maybePop(),
       );

  /// 标题文字。
  final String? title;

  /// 自定义标题组件（优先级高于 title）。
  final Widget? titleWidget;

  /// 左侧按钮（默认为空，可自定义）。
  final Widget? leading;

  /// 右侧操作按钮列表。
  final List<Widget>? actions;

  /// 标题是否居中。
  final bool centerTitle;

  /// 背景色（默认使用主题色）。
  final Color? backgroundColor;

  /// 阴影高度。
  final double elevation;

  /// 底部组件（如 TabBar）。
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title:
          titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: SATextStyles.headlineSmall.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                )
              : null),
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      elevation: elevation,
      bottom: bottom,
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
    );
  }
}

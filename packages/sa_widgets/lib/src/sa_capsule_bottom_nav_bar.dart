import 'package:flutter/material.dart';
import 'package:sa_theme/sa_theme.dart';
import 'package:sa_widgets/src/sa_bottom_nav_bar.dart';

/// 胶囊高亮式底部导航栏。
///
/// 与 [SABottomNavBar] 共用 [SATabItem] 数据模型，区别在于**选中项展开成
/// 一颗"图标 + 文字"的胶囊**，未选中项只保留图标：
///
/// ```dart
/// SACapsuleBottomNavBar(
///   tabs: _tabs,
///   currentIndex: _currentIndex,
///   onTap: (index) => setState(() => _currentIndex = index),
/// )
/// ```
///
/// 切换时胶囊底色、内边距、图标与文字同步过渡，相邻 Tab 因可用空间变化而
/// 平滑让位，形成"胶囊在 Tab 之间滑动"的视觉效果。
class SACapsuleBottomNavBar extends StatelessWidget {
  /// 创建胶囊式底部导航栏。
  ///
  /// 至少配置一个 Tab；[currentIndex] 超出范围时视为未选中。
  const SACapsuleBottomNavBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.pillColor,
    this.pillContentColor,
    this.iconColor,
    this.duration = const Duration(milliseconds: 260),
    this.curve = Curves.easeOutCubic,
    super.key,
  });

  /// 胶囊区域高度（不含底部安全区）。
  static const double height = 64;

  /// Tab 数据列表。
  final List<SATabItem> tabs;

  /// 当前选中索引。
  final int currentIndex;

  /// Tab 点击回调。
  final ValueChanged<int> onTap;

  /// 导航栏背景色，默认取主题 `surface`。
  final Color? backgroundColor;

  /// 选中胶囊底色，默认取主题 `textPrimary`（暗色模式下自动反相）。
  final Color? pillColor;

  /// 胶囊内图标与文字颜色，默认取主题 `textInverse`。
  final Color? pillContentColor;

  /// 未选中图标颜色，默认取主题 `iconDefault`。
  final Color? iconColor;

  /// 切换动画时长。
  final Duration duration;

  /// 切换动画曲线。
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final pill = pillColor ?? colors.textPrimary;
    final onPill = pillContentColor ?? colors.textInverse;

    return Material(
      color: backgroundColor ?? colors.surface,
      clipBehavior: Clip.hardEdge,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: height,
          // 各 Tab 按自身内容宽度排布、间距均分：胶囊长大时相邻 Tab 会被
          // 平滑推开，形成"胶囊在 Tab 间滑动"的效果。
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final (index, item) in tabs.indexed)
                Flexible(
                  // 选中项预留更大空间，保证窄屏下"图标 + 文字"仍放得下。
                  flex: index == currentIndex ? 2 : 1,
                  child: _CapsuleTab(
                    key: ValueKey<String>('sa-capsule-tab-${item.label}'),
                    index: index,
                    item: item,
                    isSelected: index == currentIndex,
                    onTap: onTap,
                    pillColor: pill,
                    selectedContentColor: onPill,
                    idleContentColor: iconColor ?? colors.iconDefault,
                    duration: duration,
                    curve: curve,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 单个 Tab：未选中为纯图标，选中为图标 + 文字胶囊。
class _CapsuleTab extends StatelessWidget {
  const _CapsuleTab({
    required this.index,
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.pillColor,
    required this.selectedContentColor,
    required this.idleContentColor,
    required this.duration,
    required this.curve,
    super.key,
  });

  final int index;
  final SATabItem item;
  final bool isSelected;
  final ValueChanged<int> onTap;
  final Color pillColor;
  final Color selectedContentColor;
  final Color idleContentColor;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final contentColor = isSelected ? selectedContentColor : idleContentColor;

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(SARadius.full),
        child: AnimatedContainer(
          duration: duration,
          curve: curve,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? SASpacing.lg : SASpacing.md,
            vertical: SASpacing.md,
          ),
          decoration: BoxDecoration(
            color: isSelected ? pillColor : Colors.transparent,
            borderRadius: BorderRadius.circular(SARadius.full),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: duration,
                switchInCurve: curve,
                switchOutCurve: curve,
                child: Icon(
                  isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                  key: ValueKey<bool>(isSelected),
                  size: 24,
                  color: contentColor,
                ),
              ),
              // 极窄屏幕上空间不足时，只压缩文字（省略号），不让 Row 溢出。
              Flexible(
                child: AnimatedCrossFade(
                  duration: duration,
                  sizeCurve: curve,
                  firstCurve: curve,
                  secondCurve: curve,
                  alignment: Alignment.centerLeft,
                  crossFadeState: isSelected
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(left: SASpacing.xs),
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: SATextStyles.labelLarge.copyWith(
                        color: contentColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

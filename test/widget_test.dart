import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sa_widgets/sa_widgets.dart';
import 'package:super_ability/features/courses/courses_page.dart';
import 'package:super_ability/main.dart';

const List<String> _tabLabels = ['主页', '喜欢', '课程', '个人中心', '设置'];

Finder _tab(String label) =>
    find.byKey(ValueKey<String>('sa-capsule-tab-$label'));

/// 选中项的胶囊容器。
///
/// 未选中项的文字仍留在组件树中（AnimatedCrossFade 会淡出而非移除），
/// 因此用"是否有胶囊底色"判定选中态，而不是用文字是否存在。
Finder _capsule(WidgetTester tester, String label) => find.ancestor(
  of: find.descendant(
    of: find.byType(SACapsuleBottomNavBar),
    matching: find.text(label),
  ),
  matching: find.byWidgetPredicate(
    (Widget widget) =>
        widget is Container && widget.decoration is BoxDecoration,
  ),
);

Color _capsuleColor(WidgetTester tester, String label) {
  final capsule = _capsule(tester, label);
  expect(capsule, findsOneWidget, reason: '$label 找不到胶囊容器');
  final decoration =
      tester.widget<Container>(capsule).decoration! as BoxDecoration;
  return decoration.color!;
}

bool _isCapsuleHighlighted(WidgetTester tester, String label) =>
    _capsuleColor(tester, label) != Colors.transparent;

void main() {
  testWidgets('底部导航展示 5 个 Tab，仅选中项渲染胶囊', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    for (final label in _tabLabels) {
      expect(_tab(label), findsOneWidget, reason: '缺少 $label Tab');
    }
    for (final label in _tabLabels) {
      expect(
        _isCapsuleHighlighted(tester, label),
        label == '主页',
        reason: '$label 胶囊高亮态不符合预期',
      );
    }
  });

  testWidgets('点击 Tab 切换选中态并展开胶囊', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(_tab('课程'));
    await tester.pumpAndSettle();

    expect(_isCapsuleHighlighted(tester, '课程'), isTrue);
    expect(_isCapsuleHighlighted(tester, '主页'), isFalse);
    // 选中项使用实心图标，未选中项使用线性图标。
    expect(
      find.descendant(
        of: find.byType(SACapsuleBottomNavBar),
        matching: find.byIcon(Icons.menu_book),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(SACapsuleBottomNavBar),
        matching: find.byIcon(Icons.menu_book_outlined),
      ),
      findsNothing,
    );
    // 页面内容同步切换。
    expect(find.byType(CoursesPage), findsOneWidget);
  });

  testWidgets('切换过程带过渡动画而非瞬时跳变', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(_tab('设置'));
    // 切换后第一帧仍是旧状态，再推进 80ms 进入动画中途。
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));

    // 动画中途：新旧两个胶囊都处于底色渐变过程中。
    expect(_capsuleColor(tester, '设置'), isNot(Colors.transparent));
    expect(_capsuleColor(tester, '主页'), isNot(Colors.transparent));

    await tester.pumpAndSettle();
    expect(_isCapsuleHighlighted(tester, '主页'), isFalse);
    expect(_isCapsuleHighlighted(tester, '设置'), isTrue);
  });
}

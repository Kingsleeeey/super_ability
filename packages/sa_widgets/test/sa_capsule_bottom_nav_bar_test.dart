import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sa_theme/sa_theme.dart';
import 'package:sa_widgets/sa_widgets.dart';

const List<SATabItem> _tabs = [
  SATabItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: '主页'),
  SATabItem(
    icon: Icons.favorite_border,
    activeIcon: Icons.favorite,
    label: '喜欢',
  ),
  SATabItem(
    icon: Icons.menu_book_outlined,
    activeIcon: Icons.menu_book,
    label: '课程',
  ),
  SATabItem(
    icon: Icons.person_outline,
    activeIcon: Icons.person,
    label: '个人中心',
  ),
  SATabItem(
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
    label: '设置',
  ),
];

/// 模拟业务侧用法：点击后由宿主自己更新选中索引。
class _Host extends StatefulWidget {
  const _Host({
    required this.initialIndex,
    this.pillColor,
    this.pillContentColor,
    this.backgroundColor,
    this.brightness = Brightness.light,
    this.onTap,
    super.key,
  });

  final int initialIndex;
  final Color? pillColor;
  final Color? pillContentColor;
  final Color? backgroundColor;
  final Brightness brightness;
  final ValueChanged<int>? onTap;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: widget.brightness == Brightness.dark
          ? SAAppTheme.dark()
          : SAAppTheme.light(),
      home: Scaffold(
        body: const SizedBox.expand(),
        bottomNavigationBar: SACapsuleBottomNavBar(
          tabs: _tabs,
          currentIndex: _index,
          onTap: (index) {
            widget.onTap?.call(index);
            setState(() => _index = index);
          },
          pillColor: widget.pillColor,
          pillContentColor: widget.pillContentColor,
          backgroundColor: widget.backgroundColor,
        ),
      ),
    );
  }
}

Finder _tab(String label) =>
    find.byKey(ValueKey<String>('sa-capsule-tab-$label'));

/// 每个 Tab 胶囊容器当前的底色（动画过程中为插值结果）。
///
/// 未选中项的文字仍留在组件树中（AnimatedCrossFade 淡出而非移除），
/// 因此选中态一律以"是否渲染出胶囊底色"判定。
List<Color> _capsuleColors(WidgetTester tester) {
  final capsules = find.descendant(
    of: find.byType(SACapsuleBottomNavBar),
    matching: find.byWidgetPredicate(
      (widget) => widget is Container && widget.decoration is BoxDecoration,
    ),
  );
  expect(capsules, findsNWidgets(_tabs.length));
  return tester
      .widgetList<Container>(capsules)
      .map((box) => (box.decoration! as BoxDecoration).color!)
      .toList();
}

/// 当前处于高亮态的 Tab 下标。
List<int> _highlighted(WidgetTester tester) {
  final colors = _capsuleColors(tester);
  return [
    for (var index = 0; index < colors.length; index++)
      if (colors[index] != Colors.transparent) index,
  ];
}

void main() {
  Future<void> pump(
    WidgetTester tester, {
    required int initialIndex,
    ValueChanged<int>? onTap,
    Color? pillColor,
    Color? pillContentColor,
    Color? backgroundColor,
    Brightness brightness = Brightness.light,
  }) {
    return tester.pumpWidget(
      _Host(
        key: UniqueKey(),
        initialIndex: initialIndex,
        pillColor: pillColor,
        pillContentColor: pillContentColor,
        backgroundColor: backgroundColor,
        brightness: brightness,
        onTap: onTap,
      ),
    );
  }

  testWidgets('仅选中项渲染胶囊底色，其余项保持透明', (tester) async {
    await pump(tester, initialIndex: 2);
    await tester.pumpAndSettle();

    expect(_highlighted(tester), <int>[2]);
  });

  testWidgets('点击 Tab 回调对应下标', (tester) async {
    final tapped = <int>[];
    await pump(tester, initialIndex: 0, onTap: tapped.add);
    await tester.pumpAndSettle();

    await tester.tap(_tab('个人中心'));
    await tester.tap(_tab('设置'));
    await tester.pumpAndSettle();

    expect(tapped, <int>[3, 4]);
  });

  testWidgets('currentIndex 越界时没有任何高亮态', (tester) async {
    await pump(tester, initialIndex: -1);
    await tester.pumpAndSettle();
    expect(_highlighted(tester), isEmpty);

    await pump(tester, initialIndex: _tabs.length);
    await tester.pumpAndSettle();
    expect(_highlighted(tester), isEmpty);
  });

  testWidgets('选中项使用实心图标并展示文字', (tester) async {
    await pump(tester, initialIndex: 2);
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: _tab('课程'), matching: find.byIcon(Icons.menu_book)),
      findsOneWidget,
    );
    final label = tester.widget<Text>(
      find.descendant(of: _tab('课程'), matching: find.text('课程')),
    );
    expect(label.style?.color, isNot(Colors.transparent));
  });

  testWidgets('支持自定义胶囊与背景配色', (tester) async {
    const pill = Color(0xFF123456);
    const onPill = Color(0xFFABCDEF);
    const background = Color(0xFF654321);
    await pump(
      tester,
      initialIndex: 1,
      pillColor: pill,
      pillContentColor: onPill,
      backgroundColor: background,
    );
    await tester.pumpAndSettle();

    expect(_capsuleColors(tester)[1], pill);
    expect(
      tester
          .widget<Material>(
            find.descendant(
              of: find.byType(SACapsuleBottomNavBar),
              matching: find.byType(Material),
            ),
          )
          .color,
      background,
    );
    expect(
      tester
          .widget<Text>(
            find.descendant(of: _tab('喜欢'), matching: find.text('喜欢')),
          )
          .style
          ?.color,
      onPill,
    );
  });

  testWidgets('暗色模式下胶囊自动反相为浅色', (tester) async {
    await pump(tester, initialIndex: 0, brightness: Brightness.dark);
    await tester.pumpAndSettle();

    expect(_capsuleColors(tester).first, SAPalette.dark.textPrimary);
  });

  testWidgets('切换过程新旧胶囊同时渐变', (tester) async {
    await pump(tester, initialIndex: 0);
    await tester.pumpAndSettle();

    await tester.tap(_tab('设置'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));

    expect(_highlighted(tester), <int>[0, 4]);

    await tester.pumpAndSettle();
    expect(_highlighted(tester), <int>[4]);
  });

  testWidgets('胶囊宽度随切换渐变，而非瞬时跳变', (tester) async {
    await pump(tester, initialIndex: 0);
    await tester.pumpAndSettle();

    final idleWidth = tester.getSize(_tab('设置')).width;
    await tester.tap(_tab('设置'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 80));
    final midWidth = tester.getSize(_tab('设置')).width;
    await tester.pumpAndSettle();
    final finalWidth = tester.getSize(_tab('设置')).width;

    expect(finalWidth, greaterThan(idleWidth + 20));
    expect(midWidth, greaterThan(idleWidth));
    expect(midWidth, lessThan(finalWidth));
  });

  testWidgets('320pt 窄屏下 4 字标签不产生溢出', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pump(tester, initialIndex: 3);
    await tester.pumpAndSettle();

    expect(_highlighted(tester), <int>[3]);
  });

  testWidgets('向读屏软件暴露按钮与选中语义', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, initialIndex: 2);
    await tester.pumpAndSettle();

    final selected = tester.getSemantics(_tab('课程')).getSemanticsData();
    expect(selected.flagsCollection.isButton, isTrue);
    expect(selected.flagsCollection.isSelected, ui.Tristate.isTrue);
    expect(selected.label, contains('课程'));

    final idle = tester.getSemantics(_tab('设置')).getSemanticsData();
    expect(idle.flagsCollection.isSelected, ui.Tristate.isFalse);

    handle.dispose();
  });
}

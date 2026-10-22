import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sa_theme/sa_theme.dart';

Widget _wrap({
  required ThemeData theme,
  required Widget Function(BuildContext context) builder,
}) {
  return MaterialApp(
    theme: theme,
    home: Builder(builder: builder),
  );
}

void main() {
  group('SAAppTheme', () {
    test('亮色与暗色使用各自的色板', () {
      expect(
        SAAppTheme.lightTheme.extension<SAThemeTokens>()?.palette,
        SAPalette.light,
      );
      expect(
        SAAppTheme.darkTheme.extension<SAThemeTokens>()?.palette,
        SAPalette.dark,
      );
      expect(
        SAAppTheme.lightTheme.scaffoldBackgroundColor,
        SAPalette.light.background,
      );
      expect(
        SAAppTheme.darkTheme.scaffoldBackgroundColor,
        SAPalette.dark.background,
      );
      expect(SAAppTheme.lightTheme.brightness, Brightness.light);
      expect(SAAppTheme.darkTheme.brightness, Brightness.dark);
    });

    test('排版令牌接入 ThemeData', () {
      final textTheme = SAAppTheme.lightTheme.textTheme;
      expect(textTheme.bodyMedium?.fontSize, SATextStyles.bodyMedium.fontSize);
      expect(
        textTheme.headlineMedium?.fontWeight,
        SATextStyles.headlineMedium.fontWeight,
      );
      expect(textTheme.titleSmall?.fontSize, SATextStyles.titleSmall.fontSize);
      for (final style in [
        textTheme.displayLarge,
        textTheme.headlineLarge,
        textTheme.titleLarge,
        textTheme.bodyLarge,
        textTheme.labelLarge,
      ]) {
        expect(style?.color, SAPalette.light.textPrimary);
      }
    });

    test('组件主题取自色板', () {
      final theme = SAAppTheme.lightTheme;
      expect(theme.appBarTheme.backgroundColor, SAPalette.light.surface);
      expect(theme.dividerTheme.color, SAPalette.light.divider);
      expect(theme.colorScheme.primary, SAPalette.light.primary);
      expect(theme.colorScheme.outline, SAPalette.light.border);
      expect(
        theme.inputDecorationTheme.fillColor,
        SAPalette.light.surfaceMuted,
      );
      expect(theme.iconTheme.color, SAPalette.light.iconDefault);
    });

    test('动态配色只替换给定角色', () {
      final config = SAColorConfig.fromJson(const {'primary': '#FF0000'});
      final theme = SAAppTheme.light(config: config);
      expect(
        theme.extension<SAThemeTokens>()?.palette.primary,
        const Color(0xFFFF0000),
      );
      expect(theme.colorScheme.primary, const Color(0xFFFF0000));
      expect(
        theme.extension<SAThemeTokens>()?.palette.divider,
        SAPalette.light.divider,
      );
    });

    test('同一份配置在暗色下取暗色覆盖项', () {
      final config = SAColorConfig.fromJson(const {
        'light': {'primary': '#FF0000'},
        'dark': {'primary': '#00FF00'},
      });
      expect(
        SAAppTheme.dark(config: config)
            .extension<SAThemeTokens>()
            ?.palette
            .primary,
        const Color(0xFF00FF00),
      );
    });

    test('fromPalette 支持整包替换色板', () {
      final palette = SAPalette.light.withOverrides({
        SAColorRole.background: const Color(0xFF101010),
      });
      final theme = SAAppTheme.fromPalette(
        palette: palette,
        brightness: Brightness.light,
      );
      expect(theme.scaffoldBackgroundColor, const Color(0xFF101010));
    });
  });

  group('SAThemeX', () {
    testWidgets('context.colors 读取当前主题的令牌', (tester) async {
      await tester.pumpWidget(
        _wrap(
          theme: SAAppTheme.lightTheme,
          builder: (context) =>
              Text(context.colors.primary.toARGB32().toRadixString(16)),
        ),
      );

      expect(
        find.text(SAPalette.light.primary.toARGB32().toRadixString(16)),
        findsOneWidget,
      );
    });

    testWidgets('明暗模式标记与令牌一致', (tester) async {
      late BuildContext captured;
      await tester.pumpWidget(
        MaterialApp(
          theme: SAAppTheme.lightTheme,
          darkTheme: SAAppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          home: Builder(
            builder: (context) {
              captured = context;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(captured.isDarkMode, isTrue);
      expect(captured.colors.textPrimary, SAPalette.dark.textPrimary);
      expect(captured.tokens.palette, SAPalette.dark);
    });

    testWidgets('主题未安装令牌时按亮度回退而不抛异常', (tester) async {
      late SAPalette palette;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: Builder(
            builder: (context) {
              palette = context.colors;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(palette, SAPalette.dark);
    });
  });
}

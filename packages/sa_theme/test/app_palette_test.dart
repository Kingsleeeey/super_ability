import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sa_theme/sa_theme.dart';

void main() {
  group('SAPalette', () {
    test('默认亮色与暗色色板覆盖全部角色', () {
      expect(SAPalette.light.isComplete, isTrue);
      expect(SAPalette.dark.isComplete, isTrue);
      expect(SAPalette.light.colors.length, SAColorRole.values.length);
      expect(SAPalette.dark.colors.length, SAColorRole.values.length);
    });

    test('关键角色满足可读性对比', () {
      void expectReadable(Color foreground, Color background, String label) {
        final contrast =
            (foreground.computeLuminance() - background.computeLuminance())
                .abs();
        expect(contrast, greaterThan(0.5), reason: '$label 亮度差过小');
      }

      for (final palette in [SAPalette.light, SAPalette.dark]) {
        expectReadable(palette.textPrimary, palette.surface, '正文 / 容器');
        expectReadable(palette.textPrimary, palette.background, '正文 / 页面');
        expectReadable(palette.onPrimary, palette.primary, '按钮文字 / 主色');
      }
    });

    test('defaultFor 按亮度返回对应色板', () {
      expect(SAPalette.defaultFor(Brightness.light), SAPalette.light);
      expect(SAPalette.defaultFor(Brightness.dark), SAPalette.dark);
    });

    test('缺失角色回退到亮色默认值', () {
      const partial = SAPalette(
        colors: {SAColorRole.primary: Color(0xFF111111)},
      );
      expect(partial.primary, const Color(0xFF111111));
      expect(partial.divider, SAPalette.light.divider);
      expect(partial.isComplete, isFalse);
    });

    test('withOverrides 只替换给定角色，空覆盖返回自身', () {
      final merged = SAPalette.light.withOverrides({
        SAColorRole.primary: const Color(0xFFFF0000),
      });
      expect(merged.primary, const Color(0xFFFF0000));
      expect(merged.surface, SAPalette.light.surface);
      expect(
        identical(SAPalette.light, SAPalette.light.withOverrides(const {})),
        isTrue,
      );
    });

    test('toJson / fromJson 往返不丢角色', () {
      final restored = SAPalette.fromJson(SAPalette.light.toJson());
      expect(restored, SAPalette.light);
      for (final role in SAColorRole.values) {
        expect(restored[role], SAPalette.light[role], reason: '$role 丢失');
      }
    });

    test('toJson 输出可被 SAColorUtils 解析', () {
      expect(SAPalette.light.toJson().length, SAColorRole.values.length);
      for (final hex in SAPalette.light.toJson().values) {
        expect(SAColorUtils.tryParse(hex), isNotNull);
      }
    });

    test('fromJson 忽略未知键与非法值', () {
      final palette = SAPalette.fromJson(const {
        'primary': '#FF0000',
        'unknownRole': '#00FF00',
        'divider': 'oops',
      });
      expect(palette.primary, const Color(0xFFFF0000));
      expect(palette.divider, SAPalette.light.divider);
    });

    test('lerp 端点取两端色板，中间值做插值', () {
      final mid = SAPalette.light.lerp(SAPalette.dark, 0.5);
      expect(SAPalette.light.lerp(SAPalette.dark, 0), SAPalette.light);
      expect(SAPalette.light.lerp(SAPalette.dark, 1), SAPalette.dark);
      expect(mid.isComplete, isTrue);
      expect(mid.primary, isNot(SAPalette.light.primary));
    });

    test('primaryGradient 取渐变两端角色', () {
      final gradient = SAPalette.light.primaryGradient;
      expect(gradient.colors, [
        SAPalette.light.gradientStart,
        SAPalette.light.gradientEnd,
      ]);
      expect(gradient.begin, Alignment.topLeft);
    });

    test('内容相同则相等且哈希一致', () {
      final copy = SAPalette(colors: Map.of(SAPalette.light.colors));
      expect(copy, SAPalette.light);
      expect(copy.hashCode, SAPalette.light.hashCode);
    });
  });
}

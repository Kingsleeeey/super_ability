import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sa_theme/sa_theme.dart';

void main() {
  group('SAColorConfig.fromJson', () {
    test('扁平结构同时作用于亮色与暗色', () {
      final config = SAColorConfig.fromJson(const {'primary': '#FF0000'});
      expect(config.colorsFor(Brightness.light).length, 1);
      expect(config.colorsFor(Brightness.dark).length, 1);
      expect(
        config.colorsFor(Brightness.light)[SAColorRole.primary],
        const Color(0xFFFF0000),
      );
    });

    test('分模式结构按亮度取对应覆盖项', () {
      final config = SAColorConfig.fromJson(const {
        'light': {'primary': '#FF0000'},
        'dark': {'primary': '#00FF00'},
      });
      expect(config.flat, isEmpty);
      expect(
        config.colorsFor(Brightness.light)[SAColorRole.primary],
        const Color(0xFFFF0000),
      );
      expect(
        config.colorsFor(Brightness.dark)[SAColorRole.primary],
        const Color(0xFF00FF00),
      );
    });

    test('模式专属配置优先于扁平配置', () {
      const config = SAColorConfig(
        light: {SAColorRole.primary: Color(0xFFFF0000)},
        flat: {
          SAColorRole.primary: Color(0xFF0000FF),
          SAColorRole.divider: Color(0xFFEEEEEE),
        },
      );
      expect(
        config.colorsFor(Brightness.light)[SAColorRole.primary],
        const Color(0xFFFF0000),
      );
      expect(
        config.colorsFor(Brightness.light)[SAColorRole.divider],
        const Color(0xFFEEEEEE),
      );
      expect(
        config.colorsFor(Brightness.dark)[SAColorRole.primary],
        const Color(0xFF0000FF),
      );
    });

    test('未知键、非法值与非颜色字段被忽略', () {
      final config = SAColorConfig.fromJson(const {
        'primary': '#FF0000',
        'divider': 'oops',
        'notARole': '#00FF00',
        'version': 3,
      });
      expect(config.length, 1);
    });

    test('整数色值与 Color 实例都可直接下发', () {
      final config = SAColorConfig.fromJson(const {'primary': 0xFF6750A4});
      expect(config.flat[SAColorRole.primary], const Color(0xFF6750A4));
    });

    test('动态下发的分区值类型异常时不抛错', () {
      final config = SAColorConfig.fromJson(const {
        'light': <String, dynamic>{'primary': true},
        'dark': <String, dynamic>{'primary': '#00FF00'},
      });
      expect(config.colorsFor(Brightness.light), isEmpty);
      expect(config.colorsFor(Brightness.dark).length, 1);
    });

    test('空 JSON 得到空配置', () {
      expect(SAColorConfig.fromJson(const {}).isEmpty, isTrue);
      expect(SAColorConfig.fromJsonString('[]').isEmpty, isTrue);
    });

    test('toJson / fromJson 往返等价', () {
      final configs = [
        SAColorConfig.fromJson(const {'primary': '#FF0000'}),
        SAColorConfig.fromJson(const {
          'light': {'primary': '#FF0000', 'divider': '#123456'},
          'dark': {'primary': '#00FF00'},
        }),
      ];
      for (final config in configs) {
        expect(SAColorConfig.fromJson(config.toJson()), config);
      }
    });

    test('混合配置往返后按亮度取色仍等价', () {
      const mixed = SAColorConfig(
        light: {SAColorRole.primary: Color(0xFFFF0000)},
        flat: {SAColorRole.divider: Color(0xFFEEEEEE)},
      );
      final restored = SAColorConfig.fromJson(mixed.toJson());
      for (final brightness in Brightness.values) {
        expect(restored.colorsFor(brightness), mixed.colorsFor(brightness));
      }
    });

    test('combine 中后者覆盖前者', () {
      const a = SAColorConfig(light: {SAColorRole.primary: Color(0xFFFF0000)});
      const b = SAColorConfig(light: {SAColorRole.primary: Color(0xFF00FF00)});
      final merged = a.combine(b);
      expect(merged.length, 1);
      expect(merged.light[SAColorRole.primary], const Color(0xFF00FF00));
    });
  });

  group('SAPalette.applyConfig', () {
    test('只覆盖配置中的角色，其余保持默认', () {
      final config = SAColorConfig.fromJson(const {'primary': '#FF0000'});
      final palette = SAPalette.light.applyConfig(config, Brightness.light);
      expect(palette.primary, const Color(0xFFFF0000));
      expect(palette.link, SAPalette.light.link);
    });

    test('空配置返回同一实例', () {
      expect(
        identical(
          SAPalette.dark,
          SAPalette.dark.applyConfig(const SAColorConfig(), Brightness.dark),
        ),
        isTrue,
      );
    });
  });

  group('SAThemeTokens', () {
    test('withConfig 生成新令牌且空配置不复制', () {
      const config = SAColorConfig(
        light: {SAColorRole.primary: Color(0xFFFF0000)},
      );
      final tokens = SAThemeTokens.light.withConfig(config, Brightness.light);
      expect(tokens.palette.primary, const Color(0xFFFF0000));
      expect(
        SAThemeTokens.dark.withConfig(const SAColorConfig(), Brightness.dark),
        SAThemeTokens.dark,
      );
    });

    test('lerp 在两端取对应令牌', () {
      expect(
        SAThemeTokens.light.lerp(SAThemeTokens.dark, 1),
        SAThemeTokens.dark,
      );
      expect(SAThemeTokens.light.lerp(null, 0.5), SAThemeTokens.light);
    });

    test('copyWith 可替换色板', () {
      final tokens = SAThemeTokens.light.copyWith(palette: SAPalette.dark);
      expect(tokens.palette, SAPalette.dark);
    });
  });
}

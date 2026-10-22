import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sa_theme/sa_theme.dart';

void main() {
  group('SAColorUtils.tryParse', () {
    test('解析带 # 与不带 # 的十六进制', () {
      expect(SAColorUtils.tryParse('#6750A4'), const Color(0xFF6750A4));
      expect(SAColorUtils.tryParse('6750A4'), const Color(0xFF6750A4));
    });

    test('解析 8 位 AARRGGBB', () {
      expect(SAColorUtils.tryParse('#806750A4'), const Color(0x806750A4));
    });

    test('展开 3 位与 4 位缩写', () {
      expect(SAColorUtils.tryParse('#F0A'), const Color(0xFFFF00AA));
      expect(SAColorUtils.tryParse('8F0A'), const Color(0x88FF00AA));
    });

    test('纯黑是合法颜色而不是 null', () {
      expect(SAColorUtils.tryParse('#000000'), const Color(0xFF000000));
      expect(SAColorUtils.tryParse('000000'), const Color(0xFF000000));
      expect(SAColorUtils.tryParse(0), const Color(0x00000000));
    });

    test('接受 int 与 Color', () {
      expect(SAColorUtils.tryParse(0xFF6750A4), const Color(0xFF6750A4));
      expect(
        SAColorUtils.tryParse(const Color(0xFF6750A4)),
        const Color(0xFF6750A4),
      );
    });

    test('无法识别时返回 null', () {
      expect(SAColorUtils.tryParse(null), isNull);
      expect(SAColorUtils.tryParse(''), isNull);
      expect(SAColorUtils.tryParse('not-a-color'), isNull);
      expect(SAColorUtils.tryParse('#12345'), isNull);
      expect(SAColorUtils.tryParse('#GGGGGG'), isNull);
      expect(SAColorUtils.tryParse(1.5), isNull);
    });
  });

  group('SAColorUtils.parse', () {
    test('合法值返回颜色', () {
      expect(SAColorUtils.parse('#6750A4'), const Color(0xFF6750A4));
    });

    test('非法值抛出 FormatException', () {
      expect(() => SAColorUtils.parse('oops'), throwsFormatException);
      expect(() => SAColorUtils.parse(null), throwsFormatException);
    });
  });

  group('SAColorUtils.toHex', () {
    test('输出 8 位大写十六进制并可回读', () {
      const color = Color(0x806750A4);
      final hex = SAColorUtils.toHex(color);
      expect(hex, '#806750A4');
      expect(SAColorUtils.parse(hex), color);
    });

    test('半透明颜色不被补成全不透明', () {
      final hex = SAColorUtils.toHex(const Color(0x00FFFFFF));
      expect(SAColorUtils.parse(hex), const Color(0x00FFFFFF));
    });
  });
}

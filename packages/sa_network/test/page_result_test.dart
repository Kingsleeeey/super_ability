import 'package:flutter_test/flutter_test.dart';
import 'package:sa_network/sa_network.dart';

void main() {
  group('SAPageResult', () {
    test('hasMore 在未满页时为 false', () {
      const result = SAPageResult<int>(
        list: [1, 2, 3],
        page: 1,
        pageSize: 5,
        total: 3,
      );
      expect(result.hasMore, isFalse);
      expect(result.totalPages, 1);
    });

    test('hasMore 在还有下一页时为 true', () {
      final result = SAPageResult<int>(
        list: List.generate(10, (i) => i),
        page: 1,
        pageSize: 10,
        total: 25,
      );
      expect(result.hasMore, isTrue);
      expect(result.totalPages, 3);
    });

    test('最后一页 hasMore 为 false', () {
      final result = SAPageResult<int>(
        list: List.generate(5, (i) => i),
        page: 3,
        pageSize: 10,
        total: 25,
      );
      expect(result.hasMore, isFalse);
    });
  });
}

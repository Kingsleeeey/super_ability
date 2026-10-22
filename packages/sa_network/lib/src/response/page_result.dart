/// 通用分页结果。
///
/// 业务方也可以自定义分页结构，只需实现 [hasMore] 即可。
class SAPageResult<T> {
  /// 创建一个分页结果。
  const SAPageResult({
    required this.list,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  /// 当前页数据列表。
  final List<T> list;

  /// 当前页码（从 1 开始）。
  final int page;

  /// 每页大小。
  final int pageSize;

  /// 总记录数。
  final int total;

  /// 是否还有下一页。
  bool get hasMore => page * pageSize < total;

  /// 总页数。
  int get totalPages => (total + pageSize - 1) ~/ pageSize;
}

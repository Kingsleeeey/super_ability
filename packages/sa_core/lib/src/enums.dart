/// 全局枚举定义.
library;

/// 通用数据加载状态.
enum LoadStatus {
  /// 空闲状态.
  idle,

  /// 加载中.
  loading,

  /// 加载成功.
  success,

  /// 加载失败.
  failure,
}

/// 通用请求状态.
enum RequestStatus {
  /// 初始状态.
  initial,

  /// 请求中.
  loading,

  /// 请求成功.
  success,

  /// 请求失败.
  error,

  /// 无数据.
  empty,
}

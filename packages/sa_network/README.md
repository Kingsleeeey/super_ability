# sa_network

Super Ability 网络框架私有库，基于 [Dio](https://pub.dev/packages/dio) 封装。

本库**只负责网络层能力**：请求配置、拦截器链、异常转换、响应模型。
**不内置任何业务码**，业务数据解析完全由上层通过 `ApiResponseParser` 注入，保证私有库可跨项目复用。

---

## ✨ 特性

- 🧱 **无业务耦合**：不定义任何业务状态码，只处理 HTTP 层异常。
- 🎛 **可插拔拦截器**：日志、空参过滤、Auth、重试均为独立拦截器，按需组合。
- 📦 **泛型响应模型**：`ApiResponse<T>` 密封类 + `SAPageResult<T>` 通用分页。
- 🪓 **参数自动过滤**：默认剔除请求中的 `null` 字段。
- 🔁 **自动重试**：网络层错误按指数退避重试。
- 🧪 **单元测试覆盖**：响应模型、分页、拦截器均有测试用例。

---

## 📁 目录结构

```text
sa_network/
├── lib/
│   ├── sa_network.dart            # 包入口
│   └── src/
│       ├── client/
│       │   └── dio_client.dart    # DioClient 核心
│       ├── config/
│       │   └── api_config.dart    # ApiConfig
│       ├── exceptions/
│       │   └── api_exception.dart # 网络/HTTP 异常
│       ├── interceptors/
│       │   ├── auth_interceptor.dart
│       │   ├── log_interceptor.dart
│       │   ├── null_param_interceptor.dart
│       │   └── retry_interceptor.dart
│       ├── request/
│       │   └── base_request.dart  # 通用请求参数封装
│       ├── response/
│       │   ├── api_response.dart  # ApiResponse + Parser
│       │   └── page_result.dart   # SAPageResult
│       └── utils/
│           ├── header_utils.dart  # HTTP 请求头工具
│           └── url_utils.dart     # URL 编码/拼接工具
└── test/                          # 单元测试
```

---

## 🚀 快速开始

### 1. 添加依赖

```yaml
# pubspec.yaml
dependencies:
  sa_network:
    path: packages/sa_network
```

### 2. 初始化

```dart
import 'package:sa_network/sa_network.dart';

final client = DioClient(
  config: const ApiConfig(baseUrl: 'https://api.example.com'),
  interceptors: [
    AuthInterceptor(provider: MyTokenProvider()),
    RetryInterceptor(dio: client.dio, maxAttempts: 3),
  ],
);
```

### 3. 定义业务响应解析器

私有库不假设业务码字段，业务方按自己的接口规范实现 `ApiResponseParser`：

```dart
/// 假设接口返回：{ "code": 0, "message": "ok", "data": {...} }
class MyResponseParser<T> extends ApiResponseParser<T> {
  const MyResponseParser(this.fromJson);

  final T Function(Map<String, dynamic>) fromJson;

  @override
  T parse(dynamic raw) {
    final map = raw as Map<String, dynamic>;
    final code = map['code'] as int;
    if (code != 0) {
      throw ApiException(
        map['message'] as String? ?? '请求失败',
        code: code,
      );
    }
    return fromJson(map['data'] as Map<String, dynamic>);
  }
}
```

### 4. 发起请求

```dart
final response = await client.get<User>(
  '/user/1',
  parser: MyResponseParser((json) => User.fromJson(json)),
);

switch (response) {
  case ApiSuccess<User>() :
    print(response.data.name);
  case ApiError() :
    print('失败：${response.message}');
}
```

---

## 📝 请求参数封装

通过继承 `BaseRequest` 封装具体 API 请求参数，避免每个接口重复写参数组装逻辑：

```dart
class GetUserRequest extends BaseRequest {
  GetUserRequest({required this.userId});

  final String userId;

  @override
  String get path => '/users/$userId';

  @override
  String get method => 'GET';
}

class CreateUserRequest extends BaseRequest {
  CreateUserRequest({required this.name, required this.email});

  final String name;
  final String email;

  @override
  String get path => '/users';

  @override
  String get method => 'POST';

  @override
  Map<String, dynamic> get body => {
        'name': name,
        'email': email,
      };
}

// 使用
final request = GetUserRequest(userId: '123');
final response = await client.get<User>(
  request.path,
  queryParameters: request.queryParameters,
  parser: MyResponseParser((json) => User.fromJson(json)),
);
```

---

## 🔧 工具函数

### UrlUtils

```dart
// 拼接 URL
final url = UrlUtils.join('https://api.example.com', '/users/1');
// => 'https://api.example.com/users/1'

// Map 转查询字符串
final query = UrlUtils.toQueryString({'page': 1, 'size': 10});
// => 'page=1&size=10'

// 向 URL 追加参数
final fullUrl = UrlUtils.appendQuery('https://api.com/users', {'page': 1});
// => 'https://api.com/users?page=1'
```

### HeaderUtils

```dart
// Basic Auth
final auth = HeaderUtils.basicAuth('username', 'password');
// => 'Basic dXNlcm5hbWU6cGFzc3dvcmQ='

// Bearer Token
final token = HeaderUtils.bearer('eyJhbGciOiJIUzI1NiIs...');
// => 'Bearer eyJhbGciOiJIUzI1NiIs...'

// 提取 Token
final rawToken = HeaderUtils.extractToken('Bearer abc123');
// => 'abc123'

// 标准请求头
final jsonHeaders = HeaderUtils.jsonHeaders;
// => {'Content-Type': 'application/json; charset=utf-8', 'Accept': 'application/json'}
```

---

## 🧩 拦截器

| 拦截器 | 作用 | 默认启用 |
|--------|------|----------|
| `NullParameterInterceptor` | 过滤 query/body 中的 `null` 字段 | ✅ |
| `SaLogInterceptor` | Debug 模式打印请求/响应日志 | ✅ |
| `AuthInterceptor` | 自动附加 `Authorization` 头，401 时通知业务方 | 业务方按需传入 |
| `RetryInterceptor` | 网络层错误自动重试 | 业务方按需传入 |

> `RetryInterceptor` 需要 Dio 实例，请在 `DioClient` 创建后通过
> `client.addInterceptor(RetryInterceptor(dio: client.dio))` 添加。

---

## ⚠️ 异常处理

`DioClient` 只将网络层/HTTP 层异常转换为 `ApiException`：

| 场景 | 抛出类型 |
|------|----------|
| 超时 | `TimeoutException` |
| 断网 | `NetworkException` |
| HTTP 401 | `UnauthorizedException` |
| HTTP 4xx/5xx | `ApiException` / `ServerException` |
| 取消 | `ApiException('请求已取消')` |

业务码异常请在自定义 `ApiResponseParser` 中抛出 `ApiException`，
`DioClient` 会将其捕获并封装为 `ApiError` 返回。

---

## 📄 版本策略

- 当前为本地 path 依赖，后期稳定后迁移到远程 git/pub 仓库。
- 迁移时只需将 `pubspec.yaml` 中 `path` 改为远程引用，业务代码无需改动。

---

## 🧪 测试

```bash
cd packages/sa_network
flutter test
```

/// Super Ability 网络框架包。
///
/// 基于 Dio 封装的网络请求框架，提供配置化、可插拔拦截器、
/// 通用响应模型与异常处理。
///
/// 设计原则：
/// - 私有库只处理 HTTP/网络层异常，不耦合任何业务码。
/// - 业务码、数据结构由业务方通过 `ApiResponseParser` 注入。
library;

export 'src/client/dio_client.dart';
export 'src/config/api_config.dart';
export 'src/exceptions/api_exception.dart';
export 'src/interceptors/auth_interceptor.dart';
export 'src/interceptors/log_interceptor.dart';
export 'src/interceptors/null_param_interceptor.dart';
export 'src/interceptors/retry_interceptor.dart';
export 'src/request/base_request.dart';
export 'src/response/api_response.dart';
export 'src/response/page_result.dart';
export 'src/utils/header_utils.dart';
export 'src/utils/url_utils.dart';

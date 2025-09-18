import 'package:dio/dio.dart';

class DioClient {
  late String baseUrl;
  late Dio _dio;
  static DioClient? _instance;

  DioClient._(this.baseUrl, {List<Interceptor>? interceptors}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      receiveTimeout: const Duration(milliseconds: 15000),
      sendTimeout: const Duration(milliseconds: 15000),
      connectTimeout: const Duration(milliseconds: 15000),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          options.queryParameters['ts'] = timestamp;
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.type == DioExceptionType.connectionError) {
            return handler.reject(error);
          }
          return handler.next(error);
        },
      ),
    ]);

    if (interceptors != null) _dio.interceptors.addAll(interceptors);
  }

  factory DioClient.create(String baseUrl, {List<Interceptor>? interceptors}) {
    _instance = DioClient._(baseUrl, interceptors: interceptors);
    return _instance!;
  }

  static DioClient get instance {
    if (_instance == null) {
      throw StateError(
        'DioClient must be initialized with DioClient.initialize() before accessing instance.',
      );
    }
    return _instance!;
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(path,
        data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _dio.post<T>(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
  }
}

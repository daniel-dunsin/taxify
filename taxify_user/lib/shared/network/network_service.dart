import 'package:dio/dio.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:taxify_user/shared/network/network_interceptor.dart';

enum ContentType { formData, json }

class NetworkService {
  String? baseUrl;
  ContentType? contentType;
  bool? hasAuth;
  Dio? _dio;

  NetworkService({
    this.hasAuth = false,
    this.contentType = ContentType.json,
    String? baseUrl,
  }) {
    this.baseUrl = baseUrl ?? AppConstants.serverBaseUrl;
    _dio = Dio(BaseOptions(baseUrl: this.baseUrl!))
      ..interceptors.add(
        NetworkInterceptor(
          hasAuth: hasAuth!,
          usesFormData: contentType == ContentType.formData,
        ),
      );
  }

  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParamaters,
  }) {
    return _dio!.get(url, queryParameters: queryParamaters);
  }

  Future<Response<T>> post<T>(
    String url, {
    Map? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio!.post(url, queryParameters: queryParameters, data: data);
  }

  Future<Response<T>> put<T>(
    String url, {
    Map? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio!.put(url, queryParameters: queryParameters, data: data);
  }

  Future<Response<T>> delete<T>(
    String url, {
    Map<String, dynamic>? queryParamaters,
  }) {
    return _dio!.delete(url, queryParameters: queryParamaters);
  }

  Future<Response<T>> patch<T>(
    String url, {
    Map? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio!.patch(url, queryParameters: queryParameters, data: data);
  }
}

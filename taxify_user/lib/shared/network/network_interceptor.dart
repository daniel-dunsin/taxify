import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_user/presentation/onboarding/routes/onboarding_routes.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:taxify_user/shared/navigation/navigation_router.dart';
import 'package:taxify_user/shared/network/network_toast.dart';
import 'package:taxify_user/shared/storage/storage.dart';

class NetworkInterceptor extends Interceptor {
  final bool usesFormData;
  final bool hasAuth;

  NetworkInterceptor({required this.hasAuth, required this.usesFormData});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    RequestOptions requestOptions = options.copyWith(
      headers: {
        ...options.headers,
        "Content-Type":
            usesFormData ? "multipart/form-data" : "application/json",
      },
    );

    if (hasAuth) {
      final String? accessToken = await AppStorage.getString(
        key: AppStorageConstants.accessToken,
      );

      if (accessToken != null) {
        if (kDebugMode) {
          print("Token $accessToken");
        }
        requestOptions = requestOptions.copyWith(
          headers: {
            ...requestOptions.headers,
            "Authorization": "Bearer $accessToken",
          },
        );
      }
    }

    super.onRequest(requestOptions, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response!.statusCode == 403) {
      NetworkToast.handleError("Session expired, log in again.");
      _redirectToLogin();
    }

    super.onError(err, handler);
  }

  _redirectToLogin() {
    GoRouter.of(navigatorKey.currentContext!).goNamed(OnboardingRoutes.splash);
  }
}

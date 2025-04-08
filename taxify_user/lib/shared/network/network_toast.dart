import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:taxify_user/shared/navigation/navigation_router.dart';
import 'package:taxify_user/shared/utils/utils.dart';
import 'package:toastification/toastification.dart';

enum ToastType { success, error, info }

class NetworkToast {
  static void handleError(dynamic error) {
    print(error);
    dynamic errorMessage = "Something went wrong";

    if (error?.runtimeType.toString() == "String") {
      errorMessage = error;
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.unknown:
          errorMessage = "Something went wrong";
          break;
        case DioExceptionType.cancel:
          errorMessage = "Request Cancelled";
          break;
        case DioExceptionType.connectionError:
          errorMessage = "Network Error";
          break;
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          errorMessage = "Request timeout";
          break;
        default:
          errorMessage = error.response?.data?["msg"] ?? errorMessage;
      }
    }

    toastification.showCustom(
      autoCloseDuration: const Duration(seconds: 2),
      alignment: Alignment.bottomCenter,
      builder: (context, item) {
        return _buildMessage(message: errorMessage, toastType: ToastType.error);
      },
    );
  }

  static void handleSuccess(String message) {
    toastification.showCustom(
      autoCloseDuration: const Duration(seconds: 2),
      alignment: Alignment.bottomCenter,
      builder: (context, item) {
        return _buildMessage(message: message, toastType: ToastType.success);
      },
    );
  }

  static void handleInfo(String message) {
    toastification.showCustom(
      autoCloseDuration: const Duration(seconds: 2),
      alignment: Alignment.bottomCenter,
      builder: (context, item) {
        return _buildMessage(message: message, toastType: ToastType.info);
      },
    );
  }
}

Widget _buildMessage({required String message, required ToastType toastType}) {
  return Center(
    child: FractionallySizedBox(
      widthFactor: 0.9,
      alignment: Alignment.centerRight,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color:
              toastType == ToastType.error
                  ? const Color.fromARGB(104, 229, 56, 53)
                  : toastType == ToastType.success
                  ? const Color.fromARGB(75, 15, 240, 41)
                  : const Color.fromARGB(74, 15, 97, 240),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color:
                toastType == ToastType.error
                    ? AppColors.error
                    : toastType == ToastType.success
                    ? AppColors.success
                    : AppColors.info,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color:
                    toastType == ToastType.error
                        ? AppColors.error
                        : toastType == ToastType.success
                        ? AppColors.success
                        : AppColors.info,
              ),
              child: Icon(
                toastType == ToastType.error
                    ? Icons.error_outline
                    : toastType == ToastType.success
                    ? Icons.check
                    : Icons.info_outline,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    toastType == ToastType.error
                        ? "Error"
                        : toastType == ToastType.success
                        ? "Success"
                        : "Info",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color:
                          getColorSchema(
                            navigatorKey.currentContext!,
                          ).onPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color:
                          getColorSchema(
                            navigatorKey.currentContext!,
                          ).onPrimary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

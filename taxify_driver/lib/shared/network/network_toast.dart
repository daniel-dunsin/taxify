import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/navigation/navigation_router.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:toastification/toastification.dart';

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
      alignment: Alignment.topCenter,
      builder: (context, item) {
        return _buildMessage(message: errorMessage, isError: true);
      },
    );
  }

  static void handleSuccess(String message) {
    toastification.showCustom(
      autoCloseDuration: const Duration(seconds: 2),
      alignment: Alignment.topCenter,
      builder: (context, item) {
        return _buildMessage(message: message, isError: false);
      },
    );
  }
}

Widget _buildMessage({required String message, required bool isError}) {
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
              isError
                  ? const Color.fromARGB(104, 229, 56, 53)
                  : const Color.fromARGB(75, 15, 240, 41),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: isError ? AppColors.error : AppColors.success,
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
                color: isError ? AppColors.error : AppColors.success,
              ),
              child: Icon(
                isError ? Icons.error_outline : Icons.check,
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
                    isError ? "Error" : "Success",
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

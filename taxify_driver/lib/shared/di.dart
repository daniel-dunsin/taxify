import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/shared/cubits/app_cubit.dart';

void setupSharedModule() {
  getIt.registerSingleton<AppCubit>(AppCubit());
}

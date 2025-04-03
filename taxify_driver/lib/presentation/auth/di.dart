import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/domain/auth/auth_repository.dart';
import 'package:taxify_driver/domain/vehicle/vehicle_repository.dart';
import 'package:taxify_driver/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:taxify_driver/presentation/auth/blocs/sign_up_steps_bloc/sign_up_steps_bloc.dart';

void setupAuthPresentaion() {
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      authRepository: getIt.get<AuthRepository>(),
      vehicleRepository: getIt.get<VehicleRepository>(),
    ),
  );

  getIt.registerSingleton<SignUpStepsBloc>(SignUpStepsBloc());
}

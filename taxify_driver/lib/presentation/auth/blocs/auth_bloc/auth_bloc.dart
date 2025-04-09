import 'package:flutter/material.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/data/auth/verify_otp_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxify_driver/data/user/user_model.dart';
import 'package:taxify_driver/data/vehicles/nhtsa_vehicle_model.dart';
import 'package:taxify_driver/data/vehicles/vehicle_category_model.dart';
import 'package:taxify_driver/data/vehicles/vehicle_make_model.dart';
import 'package:taxify_driver/domain/auth/auth_repository.dart';
import 'package:taxify_driver/data/payment/bank_model.dart';
import 'package:taxify_driver/domain/payment/payment_repository.dart';
import 'package:taxify_driver/domain/user/user_repository.dart';
import 'package:taxify_driver/domain/vehicle/vehicle_repository.dart';
import 'package:taxify_driver/presentation/auth/blocs/sign_up_steps_bloc/sign_up_steps_bloc.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/network/network_toast.dart';
import 'package:taxify_driver/shared/storage/storage.dart';

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  final AuthRepository authRepository;
  final VehicleRepository vehicleRepository;
  final PaymentRepository paymentRepository;
  final UserRepository userRepository;

  AuthBloc({
    required this.authRepository,
    required this.vehicleRepository,
    required this.paymentRepository,
    required this.userRepository,
  }) : super(AuthInitialState()) {
    on<SignUpRequested>((event, emit) async {
      emit(SignUpLoading());

      try {
        final signUpData = getIt.get<SignUpStepsBloc>().state.signUpModel;

        await authRepository.signUp(signUpData);

        emit(SignUpSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(SignUpFailed());
      }
    });

    on<RequestLoginOtpRequested>((event, emit) async {
      emit(RequestLoginLoading());

      try {
        final response = await authRepository.requestLoginOtp(
          event.phoneNumber,
        );

        final bool isVerified = response["data"]?["is_verified"];
        final String? email = response["data"]?["email"];

        emit(RequestLoginSuccess(isVerified: isVerified, email: email));
      } catch (e) {
        NetworkToast.handleError(e);
        emit(RequestLoginFailed());
      }
    });

    on<VerifySignUpOtpRequested>((event, emit) async {
      emit(VerifyOtpLoading());

      try {
        await authRepository.verifySignUpOtp(event.verifyOtpModel);

        emit(VerifyOtpSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(VerifyOtpFailed());
      }
    });

    on<VerifyLoginOtpRequested>((event, emit) async {
      emit(VerifyOtpLoading());

      try {
        final response = await authRepository.verifySignInOtp(
          event.verifyOtpModel,
        );

        final accessToken = response["data"]["access_token"] as String;

        await AppStorage.saveString(
          key: AppStorageConstants.accessToken,
          value: accessToken,
        );

        await userRepository.getAndRegisterUser();

        emit(VerifyOtpSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(VerifyOtpFailed());
      }
    });
    on<VerifyEmailUpdateOtpRequested>((event, emit) async {
      emit(VerifyOtpLoading());

      try {
        await userRepository.verifyEmailUpdateOtp(event.verifyOtpModel);

        await userRepository.getAndRegisterUser();

        emit(VerifyOtpSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(VerifyOtpFailed());
      }
    });

    on<GetVehicleCategoriesRequested>((event, emit) async {
      emit(GetVehicleCategoriesLoading());
      try {
        final response = await vehicleRepository.getVehicleCategories();

        final data = response["data"] as List<dynamic>;

        final vehiclesCategories = List<VehicleCategoryModel>.from(
          data.map((d) => VehicleCategoryModel.fromMap(d)),
        );

        emit(GetVehicleCategoriesSuccess(vehiclesCategories));
      } catch (e) {
        NetworkToast.handleError(e);
        emit(GetVehicleCategoriesFailed());
      }
    });

    on<GetVehicleMakesRequested>((event, emit) async {
      emit(GetVehicleMakesLoading());

      try {
        final response = await vehicleRepository.getVehicleMakes(
          event.vehicleType,
        );

        final vehicleMakes = List<VehicleMakeModel>.from(
          response.map((d) => VehicleMakeModel.fromMap(d)),
        );

        emit(GetVehicleMakesSuccess(vehicleMakes));
      } catch (e) {
        NetworkToast.handleError(e);
        emit(GetVehicleMakesFailed());
      }
    });

    on<GetVehicleModelsRequested>((event, emit) async {
      emit(GetVehicleModelsLoading());

      try {
        final response = await vehicleRepository.getVehicleModels(
          vehicleMake: event.vehicleMake,
          vehicleType: event.vehicleType,
          year: event.vehicleYear,
        );

        final vehicleModels = List<NHTSAVehicleModel>.from(
          response.map((d) => NHTSAVehicleModel.fromMap(d)),
        );

        emit(GetVehicleModelsSuccess(vehicleModels));
      } catch (e) {
        NetworkToast.handleError(e);
        emit(GetVehicleModelsFailed());
      }
    });

    on<GetBanksRequested>((event, emit) async {
      emit(GetBanksLoading());
      try {
        final response = await paymentRepository.getBanks();

        final banks = List<BankModel>.from(
          response["data"]?.map((d) => BankModel.fromMap(d)),
        );

        emit(GetBanksSuccess(banks));
      } catch (e) {
        NetworkToast.handleError(e);
        emit(GetBanksFailed());
      }
    });

    on<ResolveAccountRequested>((event, emit) async {
      emit(ResolveAccountLoading());

      try {
        final response = await paymentRepository.resolveAccount(
          bankCode: event.bankCode,
          accountNumber: event.accountNumber,
        );

        final data = response["data"] as Map;

        emit(
          ResolveAccountSuccess(
            accountNumber: data["account_number"],
            accountName: data["account_name"],
          ),
        );
      } catch (e) {
        NetworkToast.handleError(e);
        emit(ResolveAccountFailed());
      }
    });

    on<GetUserRequested>((event, emit) async {
      emit(GetUserLoading());

      try {
        final response = await userRepository.getUser();

        final User user = User.fromMap(response?["data"]);

        if (getIt.isRegistered<User>()) {
          getIt.unregister<User>();
        }

        getIt.registerSingleton<User>(user);
        emit(GetUserSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(GetUserFailed());
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(SignOutLoading());

      try {
        await authRepository.signOut();

        await AppStorage.removeObject(key: AppStorageConstants.accessToken);
        getIt.unregister<User>();

        emit(SignOutSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(SignOutFailed());
      }
    });
  }
}

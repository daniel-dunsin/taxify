import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxify_driver/domain/user/user_repository.dart';
import 'package:taxify_driver/shared/network/network_toast.dart';

part 'account_events.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvents, AccountState> {
  final UserRepository userRepository;

  AccountBloc({required this.userRepository}) : super(AccountInitialState()) {
    on<UpdateNameRequested>((event, emit) async {
      emit(UpdateNameLoading());

      try {
        await userRepository.updateNames(
          firstName: event.firstName,
          lastName: event.lastName,
        );

        await userRepository.getAndRegisterUser();

        emit(UpdateNameSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(UpdateNameFailed());
      }
    });

    on<UpdateEmailRequested>((event, emit) async {
      emit(UpdateEmailLoading());

      try {
        await userRepository.requestEmailUpdate(event.email);

        await userRepository.getAndRegisterUser();

        emit(UpdateEmailSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(UpdateEmailFailed());
      }
    });

    on<UpdatePhoneNumberRequested>((event, emit) async {
      emit(UpdatePhoneNumberLoading());

      try {
        await userRepository.updatePhoneNumber(phoneNumber: event.phoneNumber);

        await userRepository.getAndRegisterUser();

        emit(UpdatePhoneNumberSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(UpdatePhoneNumberFailed());
      }
    });

    on<UpdateProfilePictureRequested>((event, emit) async {
      emit(UpdateProfilePictureLoading());

      try {
        await userRepository.updateProfilePicture(event.profilePicture);

        await userRepository.getAndRegisterUser();

        emit(UpdateProfilePictureSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(UpdateProfilePictureFailed());
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxify_user/data/user/address_model.dart';
import 'package:taxify_user/domain/user/user_repository.dart';
import 'package:taxify_user/shared/network/network_toast.dart';

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

    on<GetAddressesRequested>((event, emit) async {
      emit(GetAddressesLoading());
      try {
        final response = await userRepository.getAddresses();

        final List<AddressModel> others = List<AddressModel>.from(
          response["data"]?["others"].map((adr) => AddressModel.fromMap(adr)),
        );

        final AddressModel? home =
            response["data"]?["home"] != null
                ? AddressModel.fromMap(response["data"]["home"])
                : null;

        final AddressModel? work =
            response["data"]?["work"] != null
                ? AddressModel.fromMap(response["data"]["work"])
                : null;

        emit(GetAddressesSuccess(others: others, home: home, work: work));
      } catch (e) {
        NetworkToast.handleError(e);
        emit(GetAddressesFailed());
      }
    });

    on<CreateAddressRequested>((event, emit) async {
      emit(CreateAddressLoading());

      try {
        await userRepository.createAddress(event.address);

        await userRepository.getAndRegisterUser();

        emit(CreateAddressSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(CreateAddressFailed());
      }
    });

    on<UpdateAddressRequested>((event, emit) async {
      emit(UpdateAddressLoading());

      try {
        await userRepository.updateAddress(event.address);

        if (event.address.isHomeAddress || event.address.isWorkAddress) {
          await userRepository.getAndRegisterUser();
        }

        emit(UpdateAddressSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(UpdateAddressFailed());
      }
    });

    on<DeleteAddressRequested>((event, emit) async {
      emit(DeleteAddressLoading());

      try {
        await userRepository.deleteAddress(event.addressId);

        await userRepository.getAndRegisterUser();

        emit(DeleteAddressSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(DeleteAddressFailed());
      }
    });
  }
}

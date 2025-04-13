part of 'account_bloc.dart';

@immutable
sealed class AccountState {}

class AccountInitialState extends AccountState {}

class UpdateNameLoading extends AccountState {}

class UpdateNameSuccess extends AccountState {}

class UpdateNameFailed extends AccountState {}

class UpdateEmailLoading extends AccountState {}

class UpdateEmailSuccess extends AccountState {}

class UpdateEmailFailed extends AccountState {}

class UpdatePhoneNumberLoading extends AccountState {}

class UpdatePhoneNumberSuccess extends AccountState {}

class UpdatePhoneNumberFailed extends AccountState {}

class UpdateProfilePictureLoading extends AccountState {}

class UpdateProfilePictureSuccess extends AccountState {}

class UpdateProfilePictureFailed extends AccountState {}

class CreateAddressLoading extends AccountState {}

class CreateAddressSuccess extends AccountState {}

class CreateAddressFailed extends AccountState {}

class GetAddressesLoading extends AccountState {}

class GetAddressesSuccess extends AccountState {
  final List<AddressModel> others;
  final AddressModel? home;
  final AddressModel? work;

  GetAddressesSuccess({required this.others, this.home, this.work});
}

class GetAddressesFailed extends AccountState {}

class UpdateAddressLoading extends AccountState {}

class UpdateAddressSuccess extends AccountState {}

class UpdateAddressFailed extends AccountState {}

class DeleteAddressLoading extends AccountState {}

class DeleteAddressSuccess extends AccountState {}

class DeleteAddressFailed extends AccountState {}

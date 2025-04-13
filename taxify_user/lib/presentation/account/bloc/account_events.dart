part of 'account_bloc.dart';

@immutable
sealed class AccountEvents {}

class UpdateNameRequested extends AccountEvents {
  final String firstName;
  final String lastName;

  UpdateNameRequested({required this.firstName, required this.lastName});
}

class UpdateEmailRequested extends AccountEvents {
  final String email;

  UpdateEmailRequested({required this.email});
}

class UpdatePhoneNumberRequested extends AccountEvents {
  final String phoneNumber;

  UpdatePhoneNumberRequested({required this.phoneNumber});
}

class UpdateProfilePictureRequested extends AccountEvents {
  final String profilePicture;

  UpdateProfilePictureRequested({required this.profilePicture});
}

class CreateAddressRequested extends AccountEvents {
  final AddressModel address;

  CreateAddressRequested(this.address);
}

class UpdateAddressRequested extends AccountEvents {
  final AddressModel address;

  UpdateAddressRequested(this.address);
}

class DeleteAddressRequested extends AccountEvents {
  final String addressId;

  DeleteAddressRequested({required this.addressId});
}

class GetAddressesRequested extends AccountEvents {}

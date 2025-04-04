import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:taxify_driver/data/payment/bank_model.dart';
import 'package:taxify_driver/data/vehicles/vehicle_category_model.dart';
import 'package:taxify_driver/shared/utils/file_utils.dart';
import 'package:taxify_driver/shared/utils/utils.dart';

class SignUpModel {
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final File? profilePicture;
  final String? ninNumber;
  final File? nin;
  final File? birthCertificate;
  final File? driversLicenseFrontImage;
  final File? driversLicenseBackImage;
  final VehicleCategoryModel? vehicleCategory;
  final String? vehicleMake;
  final String? vehicleModel;
  final int? vehicleYear;
  final String? vehiclePlateNumber;
  final int? vehiclePassengersCount;
  final File? vehicleRegistrationCertificate;
  final DateTime? vehicleRegistrationDate;
  final Color? vehicleColor;
  final List<String> vehicleRules;
  final String? accountNumber;
  final String? accountName;
  final BankModel? bank;

  SignUpModel({
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profilePicture,
    this.ninNumber,
    this.nin,
    this.birthCertificate,
    this.driversLicenseFrontImage,
    this.driversLicenseBackImage,
    this.vehicleCategory,
    this.vehicleMake,
    this.vehicleModel,
    this.vehicleYear,
    this.vehiclePlateNumber,
    this.vehiclePassengersCount,
    this.vehicleRegistrationCertificate,
    this.vehicleRegistrationDate,
    this.vehicleColor,
    this.vehicleRules = const [],
    this.accountNumber,
    this.accountName,
    this.bank,
  });

  Future<Map<String, dynamic>> toMap() async {
    return <String, dynamic>{
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profilePicture': await FileUtils.convertImageToBase64(profilePicture!),
      'nin_number': ninNumber,
      'nin': await FileUtils.convertImageToBase64(nin!),
      'birth_certificate': await FileUtils.convertImageToBase64(
        birthCertificate!,
      ),
      'drivers_license_front_image': await FileUtils.convertImageToBase64(
        driversLicenseFrontImage!,
      ),
      'drivers_license_back_image': await FileUtils.convertImageToBase64(
        driversLicenseBackImage!,
      ),
      'vehicle_category_id': vehicleCategory?.id,
      'vehicle_make': vehicleMake,
      'vehicle_model': vehicleModel,
      'vehicle_year': vehicleYear,
      'vehicle_plate_number': vehiclePlateNumber,
      'vehicle_passengers_count': vehiclePassengersCount,
      'vehicle_registration_certificate': await FileUtils.convertImageToBase64(
        vehicleRegistrationCertificate!,
      ),
      'vehicle_registration_date': vehicleRegistrationDate?.toIso8601String(),
      'vehicle_color': vehicleColor == null ? null : colorToHex(vehicleColor!),
      'vehicle_rules': vehicleRules,
      'account_number': accountNumber,
      'account_name': accountName,
      'bank_name': bank?.name,
      'bank_code': bank?.code,
      "bank_logo": bank?.logo,
    };
  }

  SignUpModel copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    File? profilePicture,
    String? ninNumber,
    File? nin,
    File? birthCertificate,
    File? driversLicenseFrontImage,
    File? driversLicenseBackImage,
    VehicleCategoryModel? vehicleCategory,
    String? vehicleMake,
    String? vehicleModel,
    int? vehicleYear,
    String? vehiclePlateNumber,
    int? vehiclePassengersCount,
    File? vehicleRegistrationCertificate,
    DateTime? vehicleRegistrationDate,
    Color? vehicleColor,
    List<String>? vehicleRules,
    String? accountNumber,
    String? accountName,
    BankModel? bank,
    bool enforceNullFile = false,
  }) {
    return SignUpModel(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture:
          enforceNullFile
              ? profilePicture
              : profilePicture ?? this.profilePicture,
      ninNumber: ninNumber ?? this.ninNumber,
      nin: enforceNullFile ? nin : nin ?? this.nin,
      birthCertificate:
          enforceNullFile
              ? birthCertificate
              : birthCertificate ?? this.birthCertificate,
      driversLicenseFrontImage:
          enforceNullFile
              ? driversLicenseFrontImage
              : driversLicenseFrontImage ?? this.driversLicenseFrontImage,
      driversLicenseBackImage:
          enforceNullFile
              ? driversLicenseBackImage
              : driversLicenseBackImage ?? this.driversLicenseBackImage,
      vehicleCategory: vehicleCategory ?? this.vehicleCategory,
      vehicleMake: vehicleMake ?? this.vehicleMake,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleYear: vehicleYear ?? this.vehicleYear,
      vehiclePlateNumber: vehiclePlateNumber ?? this.vehiclePlateNumber,
      vehiclePassengersCount:
          vehiclePassengersCount ?? this.vehiclePassengersCount,
      vehicleRegistrationCertificate:
          enforceNullFile
              ? vehicleRegistrationCertificate
              : vehicleRegistrationCertificate ??
                  this.vehicleRegistrationCertificate,
      vehicleRegistrationDate:
          vehicleRegistrationDate ?? this.vehicleRegistrationDate,
      vehicleColor: vehicleColor ?? this.vehicleColor,
      vehicleRules: vehicleRules ?? this.vehicleRules,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      bank: bank,
    );
  }

  @override
  String toString() {
    return 'SignUpModel(email: $email, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, profilePicture: $profilePicture, ninNumber: $ninNumber, nin: $nin, birthCertificate: $birthCertificate, driversLicenseFrontImage: $driversLicenseFrontImage, driversLicenseBackImage: $driversLicenseBackImage, vehicleCategory: $vehicleCategory, vehicleMake: $vehicleMake, vehicleModel: $vehicleModel, vehicleYear: $vehicleYear, vehiclePlateNumber: $vehiclePlateNumber, vehiclePassengersCount: $vehiclePassengersCount, vehicleRegistrationCertificate: $vehicleRegistrationCertificate, vehicleRegistrationDate: $vehicleRegistrationDate, vehicleColor: $vehicleColor, vehicleRules: $vehicleRules, accountNumber: $accountNumber, accountName: $accountName, bank: $bank)';
  }
}

export enum TokenType {
  accountVerification = 'accountVerification',
  login = 'login',
  changeEmail = 'changeEmail',
}

export enum Role {
  User = 'User',
  Driver = 'Driver',
  Admin = 'Admin',
}

export enum VerificationDocuments {
  NIN = 'National Identification Number (NIN)',
  DRIVERS_LICENSE = "Driver's license",
  VEHICLE_REGISTRATION = 'Vehicle Registration Certificate',
  BIRTH_CERTIFICATE = 'Birth Certificate',
}

export enum VehicleType {
  Economy = 'Economy',
  SUV = 'SUV',
  Luxury = 'Luxury',
}

export enum DriverStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE',
}

export enum PresetAddresses {
  Home = 'home',
  Work = 'work',
}

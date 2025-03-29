export enum TokenType {
  password_reset = 'password_reset',
  account_verification = 'account_verification',
  login = 'login',
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
  Premium = 'Premium',
}

export enum DriverStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE',
}

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

export enum TranasactionReason {
  FundWallet = 'fund-wallet',
  Ride = 'ride',
  ChargeCard = 'charge-card',
}

export enum TransactionDirection {
  Credit = 'Credit',
  Debit = 'Debit',
}

export enum TransactionStatus {
  Pending = 'pending',
  Successful = 'successful',
  Failed = 'failed',
  Refunded = 'refunded',
}

export enum PaymentMethods {
  CARD = 'card',
  CASH = 'cash',
  WALLET = 'wallet',
}

export enum PaystackChannels {
  card = 'card',
  bank = 'bank',
  ussd = 'ussd',
  bank_transfer = 'bank_transfer',
}

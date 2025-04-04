import {
  DriverStatus,
  Role,
  TokenType,
  VehicleType,
  VerificationDocuments,
} from './enums';

type DbMixins = {
  _id: string;
  createdAt: Date;
  updatedAt: Date;
};

export type Location = {
  type: 'Point';
  coordinates: [number, number];
};

export type BankDetails = {
  account_number: string;
  account_name: string;
  bank_code: string;
  bank_name: string;
  bank_logo: string;
};

export interface Auth extends DbMixins {
  user: User;
  email_verified: boolean;
  accessToken: string;
  accessTokenExpiresAt: Date;
}

export interface Token extends DbMixins {
  identifier: string;
  value: string;
  token_type: TokenType;
  expires_at: Date;
}

export interface User extends DbMixins {
  firstName: string;
  lastName: string;
  phoneNumber: string;
  email: string;
  role: Role;
  profile_picture: string;
  profile_picture_id: string;
}

export interface Driver extends DbMixins {
  user: User;
  is_verified: boolean;
  is_online: boolean;
  status: DriverStatus;
}

export interface VerificationDocument extends DbMixins {
  name: VerificationDocuments;
  front_image_url: string;
  back_image_url: string;
  front_image_id: string;
  back_image_id: string;
  text: string;
  driver: Driver;
  vehicle: Vehicle;
  is_approved: boolean;
}

export interface Vehicle extends DbMixins {
  group: VehicleGroup;
  make: string;
  model: string;
  year: number;
  driver: Driver;
  plate_number: string;
  passengers_count: number;
  category: VehicleCategory;
  color: string;
  registration_date: Date;
  rules: string[];
}

export interface VehicleGroup {
  name: VehicleType;
  min_fare: number;
  rate_per_km: number;
  description: string;
}

export interface VehicleCategory extends DbMixins {
  name: string;
  image: string;
  rate_discount_amount: number;
  map_image?: string;
}

export interface Wallet extends DbMixins, BankDetails {
  driver: Driver;
  user: User;
  balance: number;
  currency: string;
  currency_symbol: string;
}

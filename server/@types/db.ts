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

export interface Auth extends DbMixins {
  user: User;
  password: string;
  password_history: string[];
  email_verified: boolean;
  accessToken: string;
  refreshToken: string;
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
  current_location: Location;
}

export interface Driver extends DbMixins {
  user: User;
  is_verified: boolean;
  is_online: boolean;
  status: DriverStatus;
}

export interface VerificationDocument extends DbMixins {
  name: VerificationDocuments;
  url: string;
  text: string;
  driver: Driver;
  vehicle: Vehicle;
  is_approved: boolean;
}

export interface Vehicle extends DbMixins {
  group: VehicleGroup;
  make: string;
  model: string;
  year: string;
  driver: Driver;
  plate_number: string;
  passengers_count: number;
  category: VehicleCategory;
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
  image_id: string;
  rate_discount_amount: number;
}

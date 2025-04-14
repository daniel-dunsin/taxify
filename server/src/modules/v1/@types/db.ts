import { CardAuthorization } from '../providers/paystack/types';
import {
  DriverStatus,
  PaymentMethods,
  PaystackChannels,
  PresetAddresses,
  Role,
  TokenType,
  TranasactionReason,
  TransactionDirection,
  TransactionStatus,
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
  user: User | string;
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
  deviceToken: string;
}

export interface Driver extends DbMixins {
  user: User;
  is_verified: boolean;
  is_available: boolean;
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
  is_active: boolean;
}

export interface VehicleGroup extends DbMixins {
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
  paystack_customer_code?: string;
  paystack_customer_id?: string;
  payment_methods?: (PaymentMethod | string)[];
}

export interface Address extends DbMixins {
  state: string;
  city: string;
  country: string;
  country_iso?: string;
  street_address: string;
  place_id: string;
  place_full_text: string;
  place_description: string;
  location: Location;
  user?: User;
  name: string | PresetAddresses;
}

export interface Card extends DbMixins, CardAuthorization {
  email: string;
  user: User;
  is_active: boolean;
}

export interface Transaction extends DbMixins {
  payment_method: PaymentMethod;
  card: Card;
  payment_for: TranasactionReason;
  user: User;
  wallet: Wallet;
  amount: number;
  currency: string;
  transaction_reference: string;
  status: TransactionStatus;
  direction: TransactionDirection;
  subtotal: number;
  processing_fee: number;
  provider_transaction_id: string;
  refund_reason: string;
  amount_refunded: number;
  meta: string;
}

export interface PaymentMethod extends DbMixins {
  name: PaymentMethods;
  paystack_channel?: PaystackChannels;
  description: string;
  icon: string;
  is_for_topup: boolean;
  is_for_ride: boolean;
  is_default: boolean;
}

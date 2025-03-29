import { Role, TokenType } from './enums';

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

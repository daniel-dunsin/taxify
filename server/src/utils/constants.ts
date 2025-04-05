import { config } from 'dotenv';
import { HttpError } from '../modules/v1/@types/globals';
import * as Joi from '@hapi/joi';

config();

export enum HttpStatusCode {
  OK = 200,
  Created = 201,
  Accepted = 202,
  NoContent = 204,
  MovedPermanently = 301,
  Found = 302,
  NotModified = 304,
  BadRequest = 400,
  Unauthorized = 401,
  Forbidden = 403,
  NotFound = 404,
  InternalServerError = 500,
  NotImplemented = 501,
  BadGateway = 502,
  ServiceUnavailable = 503,
}

export enum AppErrorCode {}

export const Env = {
  validateEnv() {
    const result = Joi.object({
      PORT: Joi.string().required(),
      DATABASE_URL: Joi.string().required(),
      JWT_SECRET: Joi.string().required(),
      MAILER_PASS: Joi.string().required(),
      MAILER_USER: Joi.string().required(),
      CLOUDINARY_API_KEY: Joi.string().required(),
      CLOUDINARY_API_SECRET: Joi.string().required(),
      CLOUDINARY_CLOUD_NAME: Joi.string().required(),
      REDIS_PORT: Joi.string().required(),
      REDIS_HOST: Joi.string().required(),
      REDIS_USERNAME: Joi.string().required(),
      REDIS_PASSWORD: Joi.string().required(),
      PAYSTACK_SECRET_KEY: Joi.string().required(),
    })
      .strict(false)
      .unknown(true)
      .validate(process.env);

    if (result.error) {
      throw new HttpError(
        HttpStatusCode.BadRequest,
        `Env Validation Error: ${JSON.stringify(result.error?.message)}`
      );
    }
  },

  port: <string>process.env.PORT,
  databaseUrl: <string>process.env.DATABASE_URL,
  jwtSecret: <string>process.env.JWT_SECRET,
  paystackSecretKey: <string>process.env.PAYSTACK_SECRET_KEY,
  mailer: {
    password: <string>process.env.MAILER_PASS,
    user: <string>process.env.MAILER_USER,
  },
  cloudinary: {
    cloudName: <string>process.env.CLOUDINARY_CLOUD_NAME,
    apiSecret: <string>process.env.CLOUDINARY_API_SECRET,
    apiKey: <string>process.env.CLOUDINARY_API_KEY,
  },
  redis: {
    port: <string>process.env.REDIS_PORT,
    host: <string>process.env.REDIS_HOST,
    username: <string>process.env.REDIS_USERNAME,
    password: <string>process.env.REDIS_PASSWORD,
  },
  nodeEnv: <'development' | 'production' | 'staging'>(
    (process.env.NODE_ENV || 'development')
  ),
};

export enum DBCollections {
  Auth = 'auth',
  Token = 'token',
  User = 'user',
  Driver = 'driver',
  VerificationDocument = 'verification_document',
  Vehicle = 'vehicle',
  VehicleGroup = 'vehicle_group',
  VehicleCategory = 'vehicle_category',
  Wallet = 'wallet',
  Address = 'address',
}

export const Images = {
  profile_picture:
    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
};

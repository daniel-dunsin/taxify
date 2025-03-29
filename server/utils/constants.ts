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
      MAILER_PASSWORD: Joi.string().required(),
      MAILER_USER: Joi.string().required(),
      CLOUDINARY_API_KEY: Joi.string().required(),
      CLOUDINARY_API_SECRET: Joi.string().required(),
      CLOUDINARY_CLOUD_NAME: Joi.string().required(),
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
  mailer: {
    password: <string>process.env.MAILER_PASSWORD,
    user: <string>process.env.MAILER_USER,
  },
  cloudinary: {
    cloudName: <string>process.env.CLOUDINARY_CLOUD_NAME,
    apiSecret: <string>process.env.CLOUDINARY_API_SECRET,
    apiKey: <string>process.env.CLOUDINARY_API_KEY,
  },
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
}

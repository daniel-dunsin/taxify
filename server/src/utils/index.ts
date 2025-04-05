import { NextFunction, Request, Response } from 'express';
import { HttpError } from '../modules/v1/@types/globals';
import Logger from '../configs/logger';
import { Env, HttpStatusCode } from './constants';
import { Schema, SchemaDefinition, SchemaDefinitionType } from 'mongoose';
import { v4 } from 'uuid';
import { v2 as cloudinary_v2, UploadApiOptions } from 'cloudinary';
import path from 'path';
import ejs from 'ejs';
import { generate } from 'otp-generator';
import Jwt, { SignOptions } from 'jsonwebtoken';
import argon from 'argon2';

export function errorHandler(
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction
): any {
  const logger = new Logger('app');

  logger.error(JSON.stringify(error));

  if (error instanceof HttpError) {
    return res.status(error.statusCode).json({
      success: false,
      msg: error.message,
      name: error.name,
    });
  }

  return res.status(HttpStatusCode.InternalServerError).json({
    success: false,
    msg: error?.message || 'Oops! an error occured',
    name: 'InternalServerError',
    stackTrace: error.stack,
  });
}

export function asyncHandler(
  callback: (req: Request, res: Response, next: NextFunction) => void
) {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      const logger = new Logger('app');

      const response = await callback(req, res, next);

      let statusCode = 200;

      switch (req.method) {
        case 'POST':
          statusCode = 201;
          break;
        default:
          statusCode = 200;
      }

      logger.log(
        `${statusCode}: Request to ${req.path} completed successfully\n`
      );

      res.status(statusCode).json(
        response ?? {
          msg: 'successful',
          success: true,
        }
      );
    } catch (error) {
      return next(error);
    }
  };
}

export function createSchema<T = any>(
  modelDefinition: SchemaDefinition<SchemaDefinitionType<T>>
) {
  return new Schema<T>(
    {
      _id: {
        type: String,
        default: () => v4(),
      },
      ...modelDefinition,
    },
    {
      timestamps: true,
      virtuals: true,
      id: false,
      versionKey: false,
      toJSON: {
        virtuals: true,
      },
      toObject: {
        virtuals: true,
      },
    }
  );
}

cloudinary_v2.config({
  api_key: Env.cloudinary.apiKey,
  api_secret: Env.cloudinary.apiSecret,
  cloud_name: Env.cloudinary.cloudName,
});

export async function uploadAsset(fileOrPath: any, options?: UploadApiOptions) {
  const logger = new Logger('assetService');

  try {
    const { secure_url, public_id } = await cloudinary_v2.uploader.upload(
      fileOrPath?.path || fileOrPath,
      {
        use_asset_folder_as_public_id_prefix: true,
        folder: 'taxify_uploads',
        ...options,
      }
    );

    logger.log(
      `asset with public id ${public_id} uploaded successfully at: ${secure_url}`
    );

    return {
      url: secure_url,
      public_id,
    };
  } catch (error) {
    logger.error(`Unable to upload ${JSON.stringify(error)}`);
    throw new HttpError(
      HttpStatusCode.InternalServerError,
      'unable to process asset upload'
    );
  }
}

export async function deleteAsset(public_id: string) {
  const logger = new Logger('assetService');

  try {
    await cloudinary_v2.uploader.destroy(public_id);

    logger.log(`asset with public id ${public_id} deleted successfully`);
  } catch (error) {
    logger.error(`Unable to delete ${JSON.stringify(error)}`);
    throw new HttpError(
      HttpStatusCode.InternalServerError,
      'unable to process asset deletion'
    );
  }
}

export const renderEmailTemplate = (template: string, data: any = {}) => {
  const template_path = path.join(
    __dirname,
    '../../src/modules/v1/templates',
    template
  );

  let html = '';

  ejs.renderFile(template_path, data, (err, data) => {
    if (err) {
      throw err;
    }

    html = data;
  });

  return html;
};

export const formatCountryPhoneNumber = (
  phoneNumber: string,
  countryCode = '234'
) => {
  if (phoneNumber.startsWith('+')) {
    return phoneNumber.substring(1);
  }
  if (phoneNumber.startsWith('0')) {
    return countryCode + phoneNumber.substring(1);
  }
  if (phoneNumber.startsWith(countryCode)) {
    return phoneNumber;
  }
  return `${countryCode}${phoneNumber}`;
};

export const generateOtp = (length: number = 4) => {
  if (Env.nodeEnv === 'development') {
    return '1234';
  }

  return generate(length, {
    lowerCaseAlphabets: false,
    upperCaseAlphabets: false,
    specialChars: false,
    digits: true,
  });
};

export const signJwt = (payload: any, options?: SignOptions) => {
  const ACCESS_TOKEN_EXPIRES_AT = '30d';

  return Jwt.sign(payload, Env.jwtSecret, {
    algorithm: 'HS256',
    expiresIn: ACCESS_TOKEN_EXPIRES_AT,
    ...options,
  });
};

export const verifyJwt = async <T = any>(token: string) => {
  return Jwt.verify(token, Env.jwtSecret, {
    algorithms: ['HS256'],
    ignoreExpiration: false,
  }) as T;
};

export const hashString = async (plain: string) => {
  return await argon.hash(plain);
};

export const verifyHash = async (plain: string, hash: string) => {
  return await argon.verify(hash, plain);
};

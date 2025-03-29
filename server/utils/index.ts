import { NextFunction, Request, Response } from 'express';
import { HttpError } from '../modules/v1/@types/globals';
import Logger from '../configs/logger';
import { Env, HttpStatusCode } from './constants';
import { Schema, SchemaDefinition, SchemaDefinitionType } from 'mongoose';
import { v4 } from 'uuid';
import { v2 as cloudinary_v2, UploadApiOptions } from 'cloudinary';

export function errorHandler(
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction
): any {
  const logger = new Logger('error_handler');

  logger.error(JSON.stringify(error));

  if (error instanceof HttpError) {
    return res.status(error.statusCode).json({
      success: false,
      message: error.message,
      name: error.name,
      stackTrace: error.stackTrace,
    });
  }

  return res.status(HttpStatusCode.InternalServerError).json({
    success: false,
    message: error?.message || 'Oops! an error occured',
    name: 'InternalServerError',
    stackTrace: error.stack,
  });
}

export async function asyncHandler(
  callback: (req: Request, res: Response, next: NextFunction) => void
) {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      return callback(req, res, next);
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
  const logger = new Logger('AssetService');

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
  const logger = new Logger('AssetService');

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

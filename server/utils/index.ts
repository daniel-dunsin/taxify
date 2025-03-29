import { NextFunction, Request, Response } from 'express';
import { HttpError } from '../@types/globals';
import Logger from '../configs/logger';
import { HttpStatusCode } from './constants';
import { Schema, SchemaDefinition, SchemaDefinitionType } from 'mongoose';
import { v4 } from 'uuid';

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

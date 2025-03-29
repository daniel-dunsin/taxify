import { NextFunction, Request, Response } from 'express';
import { ObjectSchema } from '@hapi/joi';
import { HttpError } from '../../../@types/globals';
import { HttpStatusCode } from '../../../utils/constants';
import { isEmpty } from 'lodash';

export const validationMiddleware = (schema: ObjectSchema) => {
  return (req: Request, res: Response, next: NextFunction) => {
    const { error } = schema.strict(false).unknown(true).validate(req);

    if (isEmpty(error)) {
      return next();
    } else {
      throw new HttpError(
        HttpStatusCode.BadRequest,
        error?.message ||
          error?.details?.map((i) => i.message).join(', ') ||
          'Validation Error',
        'ValidationError'
      );
    }
  };
};

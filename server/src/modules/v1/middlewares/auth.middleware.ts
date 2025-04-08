import { NextFunction, Request, Response } from 'express';
import { HttpError } from '../@types/globals';
import { HttpStatusCode } from '../../../utils/constants';
import { verifyHash, verifyJwt } from '../../../utils';
import Logger from '../../../configs/logger';
import authModel from '../models/auth.model';
import { isAfter, isBefore } from 'date-fns';
import { userModel } from '../models/user.model';
import { Role } from '../@types/enums';
import { isEmpty } from 'lodash';

const logger = new Logger('authMiddleware');

export const authMiddleware =
  (roles: Role[] = []) =>
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      let authToken = req.headers['authorization'];

      if (!authToken || !authToken.startsWith('Bearer '))
        throw new HttpError(HttpStatusCode.Unauthorized, 'Provide token');

      authToken = authToken.split(' ')[1];

      const { user_id } = await verifyJwt<{ user_id: string }>(authToken);

      const auth = await authModel.findOne({ user: user_id });

      if (!auth) throw new Error('Unauthorized');
      const isWhitelistedToken = await verifyHash(authToken, auth.accessToken);

      if (!isWhitelistedToken)
        throw new HttpError(HttpStatusCode.Forbidden, 'Unauthorized access');
      if (isAfter(new Date(), auth.accessTokenExpiresAt)) {
        throw new HttpError(
          HttpStatusCode.Forbidden,
          'Session expired, login again'
        );
      }

      const user = await userModel.findById(user_id);
      if (!user) throw new Error('Unauthorized');
      if (!isEmpty(roles) && !roles.includes(user.role))
        throw new Error('Unauthorized');

      req.user = user;
      return next();
    } catch (error) {
      return next(error);
    }
  };

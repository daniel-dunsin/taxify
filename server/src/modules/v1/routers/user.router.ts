import { Router } from 'express';
import { authMiddleware } from '../middlewares/auth.middleware';
import {
  createAddress,
  deleteAddress,
  getUser,
  getUserAddresses,
  updateAddress,
} from '../controllers/user.controller';
import { Role } from '../@types/enums';
import { validationMiddleware } from '../schemas';
import {
  createAddressSchema,
  updateAddressSchema,
} from '../schemas/user.schema';

const userRouter = Router();

userRouter.get('', authMiddleware(), getUser);

userRouter.get('/address', authMiddleware([Role.User]), getUserAddresses);

userRouter.post(
  '/address',
  authMiddleware([Role.User]),
  validationMiddleware(createAddressSchema),
  createAddress
);

userRouter.put(
  '/address/:address_id',
  authMiddleware([Role.User]),
  validationMiddleware(updateAddressSchema),
  updateAddress
);

userRouter.delete(
  '/address/:address_id',
  authMiddleware([Role.User]),
  deleteAddress
);

export default userRouter;

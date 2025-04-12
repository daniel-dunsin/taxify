import { Router } from 'express';
import { authMiddleware } from '../middlewares/auth.middleware';
import {
  createAddress,
  deleteAddress,
  getUser,
  getUserAddresses,
  saveDeviceToken,
  updateAddress,
  updateUser,
  updateUserEmail,
  verifyEmailUpdate,
} from '../controllers/user.controller';
import { Role } from '../@types/enums';
import { validationMiddleware } from '../schemas';
import {
  createAddressSchema,
  saveDeviceTokenSchema,
  updateAddressSchema,
  updateEmailSchema,
  updateUserSchema,
  verifyEmailUpdateSchema,
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

userRouter.put(
  '',
  authMiddleware([Role.User, Role.Driver]),
  validationMiddleware(updateUserSchema),
  updateUser
);

userRouter.put(
  '/email/request',
  authMiddleware([Role.User, Role.Driver]),
  validationMiddleware(updateEmailSchema),
  updateUserEmail
);

userRouter.put(
  '/email/verify',
  authMiddleware([Role.User, Role.Driver]),
  validationMiddleware(verifyEmailUpdateSchema),
  verifyEmailUpdate
);

userRouter.put(
  '/device-token',
  authMiddleware(),
  validationMiddleware(saveDeviceTokenSchema),
  saveDeviceToken
);

export default userRouter;

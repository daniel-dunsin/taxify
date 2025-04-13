import { Request } from 'express';
import { asyncHandler } from '../../../utils';
import * as userService from '../services/user.service';
import {
  CreateAddressDto,
  SaveDeviceTokenDto,
  UpdateAddressDto,
  UpdateUserDto,
  UpdateUserEmailDto,
  VerifyEmailUpdateDto,
} from '../schemas/user.schema';

export const getUser = asyncHandler((req, res) =>
  userService.getUser(req.user?._id!)
);

export const createAddress = asyncHandler(
  (req: Request<{}, {}, CreateAddressDto>) => {
    return userService.createAddress(req.user?._id!, req.body);
  }
);

export const updateAddress = asyncHandler(
  (req: Request<UpdateAddressDto['params'], {}, UpdateAddressDto['body']>) => {
    return userService.updateAddress(
      req.user?._id!,
      req.params?.address_id!,
      req.body
    );
  }
);

export const getUserAddresses = asyncHandler((req) =>
  userService.getUserAddresses(req.user?._id!)
);

export const deleteAddress = asyncHandler(
  (req: Request<UpdateAddressDto['params']>) =>
    userService.deleteAddress(req.params?.address_id!)
);

export const updateUser = asyncHandler((req: Request<{}, {}, UpdateUserDto>) =>
  userService.updateUser(req.user?._id!, req.body)
);

export const updateUserEmail = asyncHandler(
  (req: Request<{}, {}, UpdateUserEmailDto>) =>
    userService.updateUserEmail(req.user?._id!, req.body)
);

export const verifyEmailUpdate = asyncHandler(
  (req: Request<{}, {}, VerifyEmailUpdateDto>) =>
    userService.verifyEmailUpdate(req.body)
);

export const saveDeviceToken = asyncHandler(
  (req: Request<{}, {}, SaveDeviceTokenDto>) =>
    userService.saveDeviceToken(req.user?._id!, req.body?.deviceToken!)
);

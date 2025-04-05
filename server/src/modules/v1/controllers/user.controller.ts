import { Request } from 'express';
import { asyncHandler } from '../../../utils';
import * as userService from '../services/user.service';
import { CreateAddressDto, UpdateAddressDto } from '../schemas/user.schema';

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
    return userService.updateAddress(req.params?.address_id!, req.body);
  }
);

export const getUserAddresses = asyncHandler((req) =>
  userService.getUserAddresses(req.user?._id!)
);

export const deleteAddress = asyncHandler(
  (req: Request<UpdateAddressDto['params']>) =>
    userService.deleteAddress(req.params?.address_id!)
);

import { isEmpty } from 'lodash';
import Logger from '../../../configs/logger';
import { HttpStatusCode } from '../../../utils/constants';
import { PresetAddresses, Role } from '../@types/enums';
import { HttpError } from '../@types/globals';
import addressModel from '../models/address.model';
import driverModel from '../models/driver.model';
import { userModel } from '../models/user.model';
import vehicleModel from '../models/vehicle.model';
import walletModel from '../models/wallet.model';
import { CreateAddressDto, UpdateAddressDto } from '../schemas/user.schema';
import { Address } from '../@types/db';

const logger = new Logger('userService');

export const getUser = async (user_id: string) => {
  const user = await userModel
    .findById(user_id)
    .select('-createdAt -updatedAt');

  if (!user) throw new HttpError(HttpStatusCode.NotFound, 'User not found');

  let data;

  if (user.role == Role.User) {
    const home_address = await addressModel
      .findOne({ user, name: PresetAddresses.Home })
      .select('-user -createdAt -updatedAt');

    const work_address = await addressModel
      .findOne({ user, name: PresetAddresses.Work })
      .select('-user -createdAt -updatedAt');

    data = {
      ...user?.toObject(),
      home_address,
      work_address,
    };
  } else if (user.role == Role.Driver) {
    const driver = await driverModel.findOne({ user });
    if (!driver)
      throw new HttpError(HttpStatusCode.NotFound, 'Driver profile not found');

    data = {
      ...user?.toObject(),
      driver_id: driver?._id,
      is_online: driver?.is_online,
      is_verified: driver?.is_verified,
    };
  } else {
    data = user;
  }

  return {
    success: true,
    msg: 'User profile retrieved successfully',
    data,
  };
};

export const createAddress = async (
  user_id: string,
  body: CreateAddressDto
) => {
  const { state, street_address, city, country, location_coordinates, name } =
    body!;

  if (!isEmpty(name)) {
    const saved_address = await addressModel.findOne({
      name: {
        $regex: new RegExp(`^${name}$`, 'i'),
      },
    });

    if (saved_address) {
      throw new HttpError(
        HttpStatusCode.BadRequest,
        'Address with this name already exists'
      );
    }
  }

  const data = await addressModel.create({
    state,
    country,
    city,
    street_address,
    name,
    location: {
      type: 'Point',
      coordinates: location_coordinates,
    },
    user: user_id,
  });

  return {
    msg: 'Location created successfully',
    success: true,
    data,
  };
};

export const getUserAddresses = async (user_id: string) => {
  const data = await addressModel
    .aggregate([
      {
        $match: { user: user_id },
      },
      {
        $project: {
          user: 0,
          createdAt: 0,
          updatedAt: 0,
        },
      },
      {
        $group: {
          _id: null,
          home: {
            $first: {
              $cond: {
                if: {
                  $eq: [
                    '$name',
                    { $regex: new RegExp(`^${PresetAddresses.Home}$`, 'i') },
                  ],
                },
                then: '$$ROOT',
                else: null,
              },
            },
          },
          work: {
            $first: {
              $cond: {
                if: {
                  $eq: [
                    '$name',
                    { $regex: new RegExp(`^${PresetAddresses.Work}$`, 'i') },
                  ],
                },
                then: '$$ROOT',
                else: null,
              },
            },
          },
          others: {
            $push: {
              $cond: [
                {
                  $nin: [
                    '$name',
                    [
                      { $regex: new RegExp(`^${PresetAddresses.Work}$`, 'i') },
                      { $regex: new RegExp(`^${PresetAddresses.Home}$`, 'i') },
                    ],
                  ],
                },
                '$$ROOT',
                '$$REMOVE',
              ],
            },
          },
        },
      },
      {
        $project: {
          home: 1,
          work: 1,
          others: 1,
        },
      },
    ])
    .then((r) => r?.[0] || { home: null, work: null, others: [] });

  return {
    success: true,
    msg: "User's addresses retrieved successfully",
    data,
  };
};

export const deleteAddress = async (address_id: string) => {
  const data = await addressModel.findByIdAndDelete(address_id);

  if (!data) throw new HttpError(HttpStatusCode.NotFound, 'Address not found');

  return {
    success: true,
    msg: 'Address deleted',
  };
};

export const updateAddress = async (
  address_id: string,
  body: UpdateAddressDto['body']
) => {
  const {
    state = null,
    street_address = null,
    city = null,
    country = null,
    location_coordinates = null,
    name = null,
  } = body!;

  if (name) {
    const existing_address = await addressModel.findOne({
      name,
      _id: { $ne: address_id },
    });

    if (existing_address)
      throw new HttpError(
        HttpStatusCode.BadRequest,
        'Address with this name already exists'
      );
  }

  const data = await addressModel.findByIdAndUpdate(
    address_id,
    {
      $set: {
        state,
        city,
        street_address,
        country,
        name,
        ...(location_coordinates && {
          location: {
            type: 'Point',
            coordinates: location_coordinates,
          },
        }),
      },
      $unset: {
        ...(!location_coordinates && { location: null }),
      },
    },
    { new: true, runValidators: false }
  );

  if (!data) throw new HttpError(HttpStatusCode.NotFound, 'Address not found');

  return {
    success: true,
    msg: 'Location updated successfully',
    data,
  };
};

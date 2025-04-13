import { isEmpty } from 'lodash';
import Logger from '../../../configs/logger';
import { HttpStatusCode } from '../../../utils/constants';
import { PresetAddresses, Role, TokenType } from '../@types/enums';
import { HttpError } from '../@types/globals';
import addressModel from '../models/address.model';
import driverModel from '../models/driver.model';
import { userModel } from '../models/user.model';
import vehicleModel from '../models/vehicle.model';
import walletModel from '../models/wallet.model';
import {
  CreateAddressDto,
  UpdateAddressDto,
  UpdateUserDto,
  UpdateUserEmailDto,
  VerifyEmailUpdateDto,
} from '../schemas/user.schema';
import { Address, User } from '../@types/db';
import {
  deleteAsset,
  formatCountryPhoneNumber,
  generateOtp,
  uploadAsset,
} from '../../../utils';
import { UpdateQuery } from 'mongoose';
import { upsertToken } from './auth.service';
import { add, isAfter } from 'date-fns';
import { emailQueue } from '../queues/email.queue';
import { tokenModel } from '../models/token.model';
import pushQueue from '../queues/push-notification';

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
      is_available: driver?.is_available,
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
  const {
    state,
    street_address,
    city,
    country,
    location_coordinates,
    name,
    country_iso,
    place_id,
    place_description,
    place_full_text,
  } = body!;

  if (!isEmpty(name)) {
    const saved_address = await addressModel.findOne({
      name: {
        $regex: new RegExp(`^${name}$`, 'i'),
      },
      user: user_id,
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
    country_iso,
    city,
    street_address,
    name,
    place_id,
    place_description,
    place_full_text,
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
  const [home, work, others] = await Promise.all([
    addressModel
      .findOne({ user: user_id, name: PresetAddresses.Home })
      .select('-user -updatedAt -createdAt'),
    addressModel
      .findOne({ user: user_id, name: PresetAddresses.Work })
      .select('-user -updatedAt -createdAt'),
    addressModel
      .find({
        user: user_id,
        name: { $nin: [PresetAddresses.Home, PresetAddresses.Work] },
      })
      .select('-user -updatedAt -createdAt'),
  ]);

  return {
    success: true,
    msg: "User's addresses retrieved successfully",
    data: {
      home,
      work,
      others,
    },
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
  user_id: string,
  address_id: string,
  body: UpdateAddressDto['body']
) => {
  const {
    state = null,
    street_address = null,
    city = null,
    country = null,
    location_coordinates = null,
    country_iso = null,
    name = null,
    place_id = null,
    place_description = null,
    place_full_text = null,
  } = body!;

  if (name) {
    const existing_address = await addressModel.findOne({
      name,
      _id: { $ne: address_id },
      user: user_id,
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
        country_iso,
        name,
        place_id,
        place_description,
        place_full_text,
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

export const updateUser = async (user_id: string, body: UpdateUserDto) => {
  const { phoneNumber, firstName, lastName, profilePicture } = body!;

  if (phoneNumber) {
    const existing_user = await userModel.findOne({
      _id: { $ne: user_id },
      phoneNumber: formatCountryPhoneNumber(phoneNumber),
    });

    if (existing_user) {
      throw new HttpError(
        HttpStatusCode.BadRequest,
        'Oops! another user exists with this phone number'
      );
    }
  }

  const user = await userModel.findById(user_id).select('+profile_picture_id');

  if (!user) throw new HttpError(HttpStatusCode.NotFound, 'User not found');

  const updatePayload: UpdateQuery<User> = {
    ...(phoneNumber && { phoneNumber: formatCountryPhoneNumber(phoneNumber) }),
    firstName,
    lastName,
  };

  if (profilePicture) {
    const { url, public_id } = await uploadAsset(profilePicture);

    updatePayload.profile_picture = url;
    updatePayload.profile_picture_id = public_id;
  }

  await userModel.updateOne({ _id: user_id }, updatePayload);

  if (user.profile_picture_id) {
    await deleteAsset(user.profile_picture_id);
  }

  return {
    success: true,
    msg: 'user updated successfully',
  };
};

export const updateUserEmail = async (
  user_id: string,
  body: UpdateUserEmailDto
) => {
  const { email } = body!;

  const user = await userModel.findById(user_id);

  if (!user) throw new HttpError(HttpStatusCode.NotFound, 'User not found');

  const existingUser = await userModel.findOne({
    _id: { $ne: user_id },
    email,
  });

  if (existingUser)
    throw new HttpError(
      HttpStatusCode.BadRequest,
      'Oops! another user exists with this email address'
    );

  const otpCode = generateOtp();

  await upsertToken({
    identifier: email,
    value: otpCode,
    token_type: TokenType.changeEmail,
    user: user._id,
    expires_at: add(new Date(), { minutes: 10 }),
  });

  await emailQueue.add({
    to: email,
    subject: 'Taxify: Verify new email',
    template: 'change-email-verification.ejs',
    context: {
      name: user?.firstName,
      otp: otpCode,
    },
  });

  return {
    success: true,
    msg: 'Success, verify new email',
  };
};

export const verifyEmailUpdate = async (body: VerifyEmailUpdateDto) => {
  const { email, otp } = body!;

  const token = await tokenModel.findOne({
    identifier: email,
    token_type: TokenType.changeEmail,
  });

  if (!token || isAfter(new Date(), token.expires_at))
    throw new HttpError(
      HttpStatusCode.BadRequest,
      'Otp is invalid or has expired'
    );

  if (token.value != otp)
    throw new HttpError(
      HttpStatusCode.BadRequest,
      'Otp is invalid or has expired'
    );

  await userModel.updateOne({ _id: token.user }, { email });
  await token.deleteOne();

  return {
    success: true,
    msg: 'Email updated',
  };
};

export const saveDeviceToken = async (userId: string, deviceToken: string) => {
  const user = await userModel.findByIdAndUpdate(userId, {
    $set: { deviceToken },
  });

  if (!user) {
    throw new HttpError(HttpStatusCode.NotFound, 'User not found');
  }

  await pushQueue.add({
    user_id: user?._id,
    title: 'Hello',
    body: 'Hi, Testing notification',
    data: {},
  });

  return {
    success: true,
    msg: 'Device token saved',
  };
};

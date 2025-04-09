import { add, isAfter } from 'date-fns';
import Logger from '../../../configs/logger';
import {
  formatCountryPhoneNumber,
  generateOtp,
  hashString,
  signJwt,
  uploadAsset,
} from '../../../utils';
import { HttpStatusCode } from '../../../utils/constants';
import { Token } from '../@types/db';
import { Role, TokenType, VerificationDocuments } from '../@types/enums';
import { HttpError } from '../@types/globals';
import authModel from '../models/auth.model';
import { tokenModel } from '../models/token.model';
import { userModel } from '../models/user.model';
import {
  DriverSignUpDto,
  LoginWithOtpDto,
  RequestLoginOtpDto,
  ResendSignUpOtpDto,
  UserSignUpDto,
  VerifyAccountDto,
} from '../schemas/auth.schema';
import { emailQueue } from '../queues/email.queue';
import driverModel from '../models/driver.model';
import vehicleModel from '../models/vehicle.model';
import vehicleCategoryModel from '../models/vehicle-category.model';
import vehicleGroupModel from '../models/vehicle-group.model';
import { getVehicleGroup } from './vehicle.service';
import verificationDocumentModel from '../models/verification-document.model';
import walletModel from '../models/wallet.model';

const logger = new Logger('authService');

const upsertJwtToken = async (user_id: string) => {
  const token = signJwt({ user_id });
  const expiresAt = add(new Date(), { days: 30 });

  const tokenHash = await hashString(token);

  await authModel.updateOne(
    { user: user_id },
    {
      $set: {
        accessToken: tokenHash,
        accessTokenExpiresAt: expiresAt,
      },
    },
    {
      runValidators: true,
    }
  );

  return { token, expiresAt };
};

export const upsertToken = async (data: Partial<Token>) => {
  await tokenModel.updateOne(
    {
      identifier: data.identifier,
      token_type: data.token_type,
    },
    {
      ...data,
    },
    {
      upsert: true,
      runValidators: true,
    }
  );
};

export const signUpUser = async (body: UserSignUpDto) => {
  const { phoneNumber, email, firstName, lastName } = body!;

  const formattedPhoneNumber = formatCountryPhoneNumber(phoneNumber);

  const existingUser = await userModel.findOne({
    $or: [
      { email },
      {
        phoneNumber: formattedPhoneNumber,
      },
    ],
  });

  if (existingUser)
    throw new HttpError(
      HttpStatusCode.BadRequest,
      'Oops! user with this phone number already exists'
    );

  const user = await userModel.create({
    firstName,
    lastName,
    email,
    phoneNumber: formattedPhoneNumber,
    role: Role.User,
  });

  await authModel.create({ user: user._id });

  await walletModel.create({ user: user._id });

  const otp = generateOtp();
  const expiresAt = add(new Date(), { hours: 3 });

  await upsertToken({
    identifier: email,
    value: otp,
    token_type: TokenType.accountVerification,
    expires_at: expiresAt,
  });

  emailQueue.add({
    to: user.email,
    subject: 'Taxify: Email Verification',
    template: 'verify-account.ejs',
    context: {
      name: user.firstName,
      otp,
    },
  });

  return {
    success: true,
    msg: 'Successful! verify account now',
  };
};

export const signUpDriver = async (body: DriverSignUpDto) => {
  const {
    firstName,
    lastName,
    email,
    phoneNumber,
    profilePicture,
    nin,
    nin_number,
    birth_certificate,
    drivers_license_back_image,
    drivers_license_front_image,
    vehicle_category_id,
    vehicle_make,
    vehicle_model,
    vehicle_year,
    vehicle_plate_number,
    vehicle_passengers_count,
    vehicle_registration_certificate,
    vehicle_registration_date,
    vehicle_color,
    vehicle_rules,
    account_name,
    account_number,
    bank_code,
    bank_name,
    bank_logo,
  } = body!;

  const formattedPhoneNumber = formatCountryPhoneNumber(phoneNumber);

  const existingUser = await userModel.findOne({
    $or: [
      { email },
      {
        phoneNumber: formattedPhoneNumber,
      },
    ],
  });

  if (existingUser)
    throw new HttpError(
      HttpStatusCode.BadRequest,
      'Oops! user with this phone number already exists'
    );

  const { url: profile_picture, public_id: profile_picture_id } =
    await uploadAsset(profilePicture);

  const user = await userModel.create({
    firstName,
    lastName,
    email,
    phoneNumber: formattedPhoneNumber,
    profile_picture,
    profile_picture_id,
    role: Role.Driver,
  });

  await authModel.create({ user: user._id });

  const driver = await driverModel.create({
    user: user._id,
    is_verified: true,
  });

  await walletModel.create({
    user: user._id,
    driver: driver._id,
    account_name,
    account_number,
    bank_code,
    bank_name,
    bank_logo,
  });

  const vehicleCategory = await vehicleCategoryModel.findById(
    vehicle_category_id
  );

  if (!vehicleCategory)
    throw new HttpError(HttpStatusCode.NotFound, 'Vehicle category not found');

  const vehicleGroup = await vehicleGroupModel.findOne({
    name: getVehicleGroup({
      cateogryName: vehicleCategory.name,
      make: vehicle_make,
      model: vehicle_model,
      passengers: vehicle_passengers_count,
      year: vehicle_year,
    }),
  });

  if (!vehicleGroup) {
    throw new HttpError(HttpStatusCode.BadRequest, 'Unable to group vehicle');
  }

  const vehicle = await vehicleModel.create({
    category: vehicle_category_id,
    make: vehicle_make,
    model: vehicle_model,
    year: vehicle_year,
    plate_number: vehicle_plate_number,
    passengers_count: vehicle_passengers_count,
    registration_date: vehicle_registration_date,
    color: vehicle_color,
    group: vehicleGroup?._id,
    rules: vehicle_rules,
    driver: driver._id,
  });

  const { url: nin_image_url, public_id: nin_image_id } = await uploadAsset(
    nin
  );

  const {
    url: birth_certificate_image_url,
    public_id: birth_certificate_image_id,
  } = await uploadAsset(birth_certificate);

  const {
    url: drivers_license_back_image_url,
    public_id: drivers_license_back_image_id,
  } = await uploadAsset(drivers_license_back_image);

  const {
    url: drivers_license_front_image_url,
    public_id: drivers_license_front_image_id,
  } = await uploadAsset(drivers_license_front_image);

  const {
    url: vehicle_registration_certificate_image_url,
    public_id: vehicle_registration_certificate_image_id,
  } = await uploadAsset(vehicle_registration_certificate);

  await verificationDocumentModel.create([
    {
      name: VerificationDocuments.NIN,
      text: nin_number,
      front_image_url: nin_image_url,
      front_image_id: nin_image_id,
      driver: driver._id,
    },
    {
      name: VerificationDocuments.BIRTH_CERTIFICATE,
      front_image_url: birth_certificate_image_url,
      front_image_id: birth_certificate_image_id,
      driver: driver._id,
    },
    {
      name: VerificationDocuments.DRIVERS_LICENSE,
      front_image_url: drivers_license_front_image_url,
      front_image_id: drivers_license_front_image_id,
      back_image_url: drivers_license_back_image_url,
      back_image_id: drivers_license_back_image_id,
      driver: driver._id,
    },
    {
      name: VerificationDocuments.VEHICLE_REGISTRATION,
      front_image_url: vehicle_registration_certificate_image_url,
      front_image_id: vehicle_registration_certificate_image_id,
      vehicle: vehicle._id,
    },
  ]);

  const otp = generateOtp();
  const expiresAt = add(new Date(), { hours: 3 });

  await upsertToken({
    identifier: email,
    value: otp,
    token_type: TokenType.accountVerification,
    expires_at: expiresAt,
  });

  emailQueue.add({
    to: user.email,
    subject: 'Taxify: Email Verification',
    template: 'verify-account.ejs',
    context: {
      name: user.firstName,
      otp,
    },
  });

  return {
    success: true,
    msg: 'Successful! verify account now',
  };
};

export const resendSignUpOtp = async (body: ResendSignUpOtpDto) => {
  const email = body?.email;

  const user = await userModel.findOne({ email });

  if (!user) throw new HttpError(HttpStatusCode.NotFound, 'User not found');

  const otp = generateOtp();
  const expiresAt = add(new Date(), { hours: 3 });

  await upsertToken({
    identifier: email,
    value: otp,
    token_type: TokenType.accountVerification,
    expires_at: expiresAt,
  });

  emailQueue.add({
    to: user.email,
    subject: 'Taxify: Email Verification',
    template: 'verify-account.ejs',
    context: {
      name: user.firstName,
      otp,
    },
  });

  return {
    success: true,
    msg: 'Successful! verify account now',
  };
};

export const verifyAccount = async (body: VerifyAccountDto) => {
  const { email, otp } = body!;

  const token = await tokenModel.findOne({
    identifier: email,
    token_type: TokenType.accountVerification,
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

  const user = await userModel.findOne({ email });

  if (!user) throw new HttpError(HttpStatusCode.NotFound, 'User not found');

  await authModel.updateOne(
    { user: user._id },
    { $set: { email_verified: true } },
    { runValidators: true }
  );

  await token.deleteOne();

  return {
    success: true,
    msg: 'Account verified',
  };
};

export const requestLoginOtp = async (body: RequestLoginOtpDto) => {
  const { phone_number, role } = body!;

  const formattedPhoneNumber = formatCountryPhoneNumber(phone_number);

  const user = await userModel.findOne({
    phoneNumber: formattedPhoneNumber,
    role,
  });

  if (!user)
    throw new HttpError(HttpStatusCode.NotFound, 'Incorrect phone number');

  const auth = await authModel.findOne({
    user: user._id,
  });

  if (!auth) throw new HttpError(HttpStatusCode.NotFound, 'User not found');

  if (!auth.email_verified) {
    const otp = generateOtp();
    const expiresAt = add(new Date(), { hours: 3 });

    await upsertToken({
      identifier: user?.email,
      value: otp,
      token_type: TokenType.accountVerification,
      expires_at: expiresAt,
    });

    emailQueue.add({
      to: user.email,
      subject: 'Taxify: Email Verification',
      template: 'verify-account.ejs',
      context: {
        name: user.firstName,
        otp,
      },
    });

    return {
      msg: 'Verify account before proceeding',
      success: true,
      data: {
        is_verified: false,
        email: user.email,
      },
    };
  }

  const otp = generateOtp();
  const expires_at = add(new Date(), { minutes: 10 });

  await upsertToken({
    identifier: formattedPhoneNumber,
    value: otp,
    token_type: TokenType.login,
    expires_at,
  });

  emailQueue.add({
    to: user.email,
    subject: 'Taxify: Login OTP',
    template: 'login-otp.ejs',
    context: {
      name: user.firstName,
      otp,
    },
  });

  return {
    msg: 'Login Otp sent successfully',
    success: true,
    data: {
      is_verified: true,
    },
  };
};

export const loginWithOtp = async (body: LoginWithOtpDto) => {
  const { phone_number, otp } = body!;

  const formattedPhoneNumber = formatCountryPhoneNumber(phone_number);

  const token = await tokenModel.findOne({
    identifier: formattedPhoneNumber,
    token_type: TokenType.login,
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

  const user = await userModel.findOne({ phoneNumber: formattedPhoneNumber });
  if (!user) throw new HttpError(HttpStatusCode.NotFound, 'User not found');

  const { token: access_token, expiresAt } = await upsertJwtToken(user._id);
  await token.deleteOne();

  return {
    success: true,
    msg: 'Login with otp successful',
    data: {
      access_token,
      access_token_expires_at: expiresAt,
    },
  };
};

export const signOut = async (user_id: string) => {
  const userAuth = await authModel.findOneAndUpdate(
    { user: user_id },
    {
      $unset: {
        accessToken: '',
        accessTokenExpiresAt: '',
      },
    }
  );

  if (!userAuth) throw new HttpError(HttpStatusCode.NotFound, 'User not found');

  return {
    success: true,
    msg: 'Signed out successfully',
  };
};

import * as Joi from '@hapi/joi';
import 'joi-extract-type';
import { Role } from '../@types/enums';

export const userSignUpSchema = Joi.object({
  body: Joi.object({
    firstName: Joi.string().required(),
    lastName: Joi.string().required(),
    email: Joi.string().required(),
    phoneNumber: Joi.string().required(),
  }),
});

export type UserSignUpDto = Joi.extractType<typeof userSignUpSchema>['body'];

export const driverSignUpSchema = Joi.object({
  body: Joi.object({
    firstName: Joi.string().required(),
    lastName: Joi.string().required(),
    email: Joi.string().email().lowercase().required(),
    phoneNumber: Joi.string().required(),
    profilePicture: Joi.string().required(),
    nin: Joi.string().optional(),
    nin_number: Joi.string().required(),
    birth_certificate: Joi.string().required(),
    drivers_license_front_image: Joi.string().required(),
    drivers_license_back_image: Joi.string().required(),
    vehicle_category_id: Joi.string().required(),
    vehicle_make: Joi.string().required(),
    vehicle_model: Joi.string().required(),
    vehicle_year: Joi.number().required(),
    vehicle_plate_number: Joi.string().required(),
    vehicle_passengers_count: Joi.number().required().min(1),
    vehicle_registration_certificate: Joi.string().required(),
    vehicle_registration_date: Joi.date().strict(false),
    vehicle_color: Joi.string().required(),
    vehicle_rules: Joi.array().items(Joi.string()).default([]),
    account_number: Joi.string().required(),
    account_name: Joi.string().required(),
    bank_name: Joi.string().required(),
    bank_code: Joi.string().required(),
  }),
});

export type DriverSignUpDto = Joi.extractType<
  typeof driverSignUpSchema
>['body'];

export const resendSignUpOtpSchema = Joi.object({
  body: Joi.object({
    email: Joi.string().email().lowercase().required(),
  }),
});

export type ResendSignUpOtpDto = Joi.extractType<
  typeof resendSignUpOtpSchema
>['body'];

export const verifyAccountSchema = Joi.object({
  body: Joi.object({
    email: Joi.string().email().lowercase().required(),
    otp: Joi.string().required(),
  }),
});

export type VerifyAccountDto = Joi.extractType<
  typeof verifyAccountSchema
>['body'];

export const requestLoginOtpSchema = Joi.object({
  body: Joi.object({
    phone_number: Joi.string().required(),
    role: Joi.string().required().allow(Role.User, Role.Driver),
  }),
});

export type RequestLoginOtpDto = Joi.extractType<
  typeof requestLoginOtpSchema
>['body'];

export const loginWithOtpSchema = Joi.object({
  body: Joi.object({
    phone_number: Joi.string().required(),
    otp: Joi.string().required(),
  }),
});

export type LoginWithOtpDto = Joi.extractType<
  typeof loginWithOtpSchema
>['body'];

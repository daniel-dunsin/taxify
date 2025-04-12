import * as Joi from '@hapi/joi';
import { coordinatesSchema } from './defaults.schema';

export const createAddressSchema = Joi.object({
  body: Joi.object({
    name: Joi.string().optional(),
    state: Joi.string().required(),
    city: Joi.string().optional(),
    street_address: Joi.string().optional(),
    country: Joi.string().required(),
    country_iso: Joi.string().optional(),
    location_coordinates: coordinatesSchema,
  }),
});

export type CreateAddressDto = Joi.extractType<
  typeof createAddressSchema
>['body'];

export const updateAddressSchema = Joi.object({
  params: Joi.object({
    address_id: Joi.string().optional(),
  }),
  body: Joi.object({
    name: Joi.string().optional(),
    state: Joi.string().optional(),
    city: Joi.string().optional(),
    street_address: Joi.string().optional(),
    country: Joi.string().optional(),
    country_iso: Joi.string().optional(),
    location_coordinates: coordinatesSchema,
  }),
});

export type UpdateAddressDto = Joi.extractType<typeof updateAddressSchema>;

export const updateUserSchema = Joi.object({
  body: Joi.object({
    firstName: Joi.string().optional(),
    lastName: Joi.string().optional(),
    profilePicture: Joi.string().optional(),
    phoneNumber: Joi.string().optional(),
  }),
});

export type UpdateUserDto = Joi.extractType<typeof updateUserSchema>['body'];

export const updateEmailSchema = Joi.object({
  body: Joi.object({
    email: Joi.string().lowercase().required(),
  }),
});

export type UpdateUserEmailDto = Joi.extractType<
  typeof updateEmailSchema
>['body'];

export const verifyEmailUpdateSchema = Joi.object({
  body: Joi.object({
    email: Joi.string().lowercase().required(),
    otp: Joi.string().required(),
  }),
});

export type VerifyEmailUpdateDto = Joi.extractType<
  typeof verifyEmailUpdateSchema
>['body'];

export const saveDeviceTokenSchema = Joi.object({
  body: Joi.object({
    deviceToken: Joi.string().required(),
  }),
});

export type SaveDeviceTokenDto = Joi.extractType<
  typeof saveDeviceTokenSchema
>['body'];

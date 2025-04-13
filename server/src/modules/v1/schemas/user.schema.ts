import * as Joi from '@hapi/joi';
import { coordinatesSchema } from './defaults.schema';

export const createAddressSchema = Joi.object({
  body: Joi.object({
    name: Joi.string().optional().allow('', null),
    state: Joi.string().required(),
    city: Joi.string().optional().allow('', null),
    street_address: Joi.string().optional().allow('', null),
    country: Joi.string().required(),
    country_iso: Joi.string().optional().allow('', null),
    location_coordinates: coordinatesSchema,
    place_id: Joi.string().optional().allow('', null),
    place_description: Joi.string().optional().allow('', null),
    place_full_text: Joi.string().optional().allow('', null),
  }),
});

export type CreateAddressDto = Joi.extractType<
  typeof createAddressSchema
>['body'];

export const updateAddressSchema = Joi.object({
  params: Joi.object({
    address_id: Joi.string().optional().allow('', null),
  }),
  body: Joi.object({
    name: Joi.string().optional().allow('', null),
    state: Joi.string().optional().allow('', null),
    city: Joi.string().optional().allow('', null),
    street_address: Joi.string().optional().allow('', null),
    country: Joi.string().optional().allow('', null),
    country_iso: Joi.string().optional().allow('', null),
    location_coordinates: coordinatesSchema,
    place_id: Joi.string().optional().allow('', null),
    place_description: Joi.string().optional().allow('', null),
    place_full_text: Joi.string().optional().allow('', null),
  }),
});

export type UpdateAddressDto = Joi.extractType<typeof updateAddressSchema>;

export const updateUserSchema = Joi.object({
  body: Joi.object({
    firstName: Joi.string().optional().allow('', null),
    lastName: Joi.string().optional().allow('', null),
    profilePicture: Joi.string().optional().allow('', null),
    phoneNumber: Joi.string().optional().allow('', null),
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

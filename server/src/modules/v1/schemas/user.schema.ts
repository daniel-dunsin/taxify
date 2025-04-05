import * as Joi from '@hapi/joi';
import { coordinatesSchema } from './defaults.schema';

export const createAddressSchema = Joi.object({
  body: Joi.object({
    name: Joi.string().optional(),
    state: Joi.string().required(),
    city: Joi.string().optional(),
    street_address: Joi.string().optional(),
    country: Joi.string().required(),
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
    location_coordinates: coordinatesSchema,
  }),
});

export type UpdateAddressDto = Joi.extractType<typeof updateAddressSchema>;

import * as Joi from '@hapi/joi';
import 'joi-extract-type';

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
    email: Joi.string().required(),
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
    vehicle_year: Joi.string().required(),
    vehicle_plate_number: Joi.string().required(),
    passengers_count: Joi.number().required().min(1),
    vehicle_registration_certificate: Joi.string().required(),
    vehicle_registration_date: Joi.date().strict(false),
    vehicle_color: Joi.string().required(),
    account_number: Joi.string().required(),
    account_name: Joi.string().required(),
    bank_name: Joi.string().required(),
    bank_code: Joi.string().required(),
  }),
});

export type DriverSignUpDto = Joi.extractType<
  typeof driverSignUpSchema
>['body'];

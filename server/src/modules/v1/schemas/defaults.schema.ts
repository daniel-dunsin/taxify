import * as Joi from '@hapi/joi';

export const coordinatesSchema = Joi.array()
  .length(2)
  .items(Joi.number().strict(true))
  .strict(true);

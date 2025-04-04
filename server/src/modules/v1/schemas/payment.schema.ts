import * as Joi from '@hapi/joi';

export const lookupAccountSchema = Joi.object({
  query: Joi.object({
    account_number: Joi.string().required(),
    bank_code: Joi.string().required(),
  }),
});

export type LookupAccountDto = Joi.extractType<
  typeof lookupAccountSchema
>['query'];

import * as Joi from '@hapi/joi';

export const updatePaymentMethodSchema = Joi.object({
  params: Joi.object({
    payment_method_id: Joi.string().optional(),
  }),
});

export type UpdatePaymentMethodParams = Joi.extractType<
  typeof updatePaymentMethodSchema
>['params'];

export const fundWalletSchema = Joi.object({
  body: Joi.object({
    payment_method_id: Joi.string().required(),
    amount: Joi.number().required(),
  }),
});

export type FundWalletDto = Joi.extractType<typeof fundWalletSchema>['body'];

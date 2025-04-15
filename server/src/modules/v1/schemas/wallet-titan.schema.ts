import * as Joi from '@hapi/joi';

export const updatePaymentMethodSchema = Joi.object({
  params: Joi.object({
    payment_method_id: Joi.string().optional(),
  }),
});

export type UpdatePaymentMethodParams = Joi.extractType<
  typeof updatePaymentMethodSchema
>['params'];

import mongoose from 'mongoose';
import { createSchema } from '../../../utils';
import { PaymentMethod } from '../@types/db';
import { PaystackChannels } from '../@types/enums';
import { DBCollections } from '../../../utils/constants';

export const PaymentMethodSchemas = createSchema<PaymentMethod>({
  name: {
    type: String,
  },
  paystack_channel: {
    type: String,
    enum: Object.values(PaystackChannels),
  },
  description: {
    type: String,
  },
  icon: {
    type: String,
  },
  is_for_ride: {
    type: Boolean,
  },
  is_for_topup: {
    type: Boolean,
  },
  is_default: {
    type: Boolean,
  },
});

const paymentMethodModel = mongoose.model(
  DBCollections.PaymentMethod,
  PaymentMethodSchemas
);
export default paymentMethodModel;

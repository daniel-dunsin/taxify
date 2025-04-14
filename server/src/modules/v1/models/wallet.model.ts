import mongoose, { MongooseQueryOrDocumentMiddleware } from 'mongoose';
import { createSchema } from '../../../utils';
import { DBCollections } from '../../../utils/constants';
import { Wallet } from '../@types/db';

const WalletSchema = createSchema<Wallet>({
  account_name: {
    type: String,
  },
  account_number: {
    type: String,
  },
  bank_name: {
    type: String,
  },
  bank_code: {
    type: String,
  },
  bank_logo: {
    type: String,
  },
  balance: {
    type: Number,
    default: 0,
  },
  user: {
    type: String,
    ref: DBCollections.User,
  },
  driver: {
    type: String,
    ref: DBCollections.Driver,
  },
  currency: {
    type: String,
    default: 'NGN',
  },
  currency_symbol: {
    type: String,
    default: '₦',
  },
  paystack_customer_code: {
    type: String,
  },
  paystack_customer_id: {
    type: String,
  },
  payment_methods: {
    type: [
      {
        type: String,
        ref: DBCollections.PaymentMethod,
      },
    ],
    default: [],
  },
});

const restrictedOperations: MongooseQueryOrDocumentMiddleware[] = [
  'deleteMany',
  'deleteOne',
  'findOneAndDelete',
];

restrictedOperations.forEach((op) =>
  WalletSchema.pre(op, function (next) {
    next(new Error('Operation not allowed on this schema'));
  })
);

const walletModel = mongoose.model(DBCollections.Wallet, WalletSchema);

export default walletModel;

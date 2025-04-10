import mongoose from 'mongoose';
import { createSchema } from '../../../utils';
import { DBCollections } from '../../../utils/constants';
import { Transaction } from '../@types/db';
import {
  PaymentMethods,
  TranasactionReason,
  TransactionDirection,
  TransactionStatus,
} from '../@types/enums';

const TransactionSchema = createSchema<Transaction>({
  payment_method: {
    type: String,
    enum: Object.values(PaymentMethods),
  },
  card: {
    type: String,
    ref: DBCollections.Card,
  },
  payment_for: {
    type: String,
    enum: Object.values(TranasactionReason),
  },
  user: {
    type: String,
    ref: DBCollections.User,
  },
  wallet: {
    type: String,
    ref: DBCollections.Wallet,
  },
  amount: {
    type: Number,
  },
  transaction_reference: {
    type: String,
  },
  status: {
    type: String,
    enum: Object.values(TransactionStatus),
  },
  direction: {
    type: String,
    enum: Object.values(TransactionDirection),
  },
  subtotal: {
    type: Number,
  },
  processing_fee: {
    type: Number,
  },
  provider_transaction_id: {
    type: String,
  },
  refund_reason: {
    type: String,
  },
  amount_refunded: {
    type: Number,
  },
  meta: {
    type: String,
  },
});

const transactionModel = mongoose.model(
  DBCollections.Transaction,
  TransactionSchema
);

export default transactionModel;

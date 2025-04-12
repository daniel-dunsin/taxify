import mongoose from 'mongoose';
import { createSchema } from '../../../utils';
import { DBCollections } from '../../../utils/constants';
import { Card } from '../@types/db';

const CardSchema = createSchema<Card>({
  email: {
    type: String,
  },
  user: {
    type: String,
    ref: DBCollections.User,
  },
  is_active: {
    type: Boolean,
    required: false,
  },
  authorization_code: {
    type: String,
  },
  bin: {
    type: String,
  },
  last4: {
    type: String,
  },
  exp_month: {
    type: String,
  },
  exp_year: {
    type: String,
  },
  bank: {
    type: String,
  },
  country_code: {
    type: String,
  },
  brand: {
    type: String,
  },
  account_name: {
    type: String,
  },
  signature: {
    type: String,
  },
});

const cardModel = mongoose.model(DBCollections.Card, CardSchema);
export default cardModel;

import mongoose from 'mongoose';
import { createSchema } from '../../../utils';
import { DBCollections } from '../../../utils/constants';
import { Address } from '../@types/db';

export const AddressSchema = createSchema<Address>({
  name: {
    type: String,
  },
  user: {
    type: String,
    ref: DBCollections.User,
  },
  state: {
    type: String,
  },
  city: {
    type: String,
  },
  country: {
    type: String,
  },
  country_iso: {
    type: String,
  },
  street_address: {
    type: String,
  },
  location: {
    type: {
      type: String,
      enum: ['Point'],
    },
    coordinates: {
      type: [Number],
    },
  },
});

AddressSchema.index({ location: '2dsphere' });

const addressModel = mongoose.model(DBCollections.Address, AddressSchema);

export default addressModel;

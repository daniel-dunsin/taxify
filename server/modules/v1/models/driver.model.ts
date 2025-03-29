import mongoose from 'mongoose';
import { Driver } from '../../../@types/db';
import { DriverStatus } from '../../../@types/enums';
import { createSchema } from '../../../utils';
import { DBCollections } from '../../../utils/constants';

const DriverSchema = createSchema<Driver>({
  user: {
    type: String,
    ref: DBCollections.User,
  },

  is_verified: {
    type: Boolean,
    default: false,
  },

  is_online: {
    type: Boolean,
    default: true,
  },

  status: {
    type: String,
    enum: Object.values(DriverStatus),
    default: DriverStatus.ACTIVE,
  },
});

const driverModel = mongoose.model(DBCollections.Driver, DriverSchema);
export default driverModel;

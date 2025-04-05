import mongoose, { MongooseQueryOrDocumentMiddleware } from 'mongoose';
import { Driver } from '../@types/db';
import { DriverStatus } from '../@types/enums';
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

const restrictedOperations: MongooseQueryOrDocumentMiddleware[] = [
  'deleteMany',
  'deleteOne',
  'findOneAndDelete',
];

restrictedOperations.forEach((op) =>
  DriverSchema.pre(op, function (next) {
    next(new Error('Operation not allowed on this schema'));
  })
);

const driverModel = mongoose.model(DBCollections.Driver, DriverSchema);
export default driverModel;

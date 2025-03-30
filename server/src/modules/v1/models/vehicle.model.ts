import mongoose from 'mongoose';
import { Vehicle } from '../@types/db';
import { createSchema } from '../../../utils';
import { DBCollections } from '../../../utils/constants';

const VehicleSchema = createSchema<Vehicle>({
  group: {
    type: String,
    ref: DBCollections.VehicleGroup,
  },
  make: {
    type: String,
  },
  model: {
    type: String,
  },
  year: {
    type: String,
  },
  driver: {
    type: String,
    ref: DBCollections.Driver,
  },
  plate_number: {
    type: String,
  },
  passengers_count: {
    type: Number,
    default: 1,
    min: 1,
  },
  category: {
    type: String,
    ref: DBCollections.VehicleCategory,
  },
  color: {
    type: String,
  },
  registration_date: {
    type: Date,
  },
  rules: {
    type: [String],
    default: [],
  },
});

const vehicleModel = mongoose.model(DBCollections.Vehicle, VehicleSchema);

export default vehicleModel;

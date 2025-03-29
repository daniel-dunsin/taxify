import mongoose from 'mongoose';
import { VehicleGroup } from '../../../@types/db';
import { VehicleType } from '../../../@types/enums';
import { createSchema } from '../../../utils';
import { DBCollections } from '../../../utils/constants';

const VehicleGroupSchema = createSchema<VehicleGroup>({
  name: {
    type: String,
    enum: Object.values(VehicleType),
    required: true,
  },

  min_fare: {
    type: Number,
    default: 0,
  },
  rate_per_km: {
    type: Number,
    default: 0,
  },
  description: {
    type: String,
  },
});

const vehicleGroupModel = mongoose.model(
  DBCollections.VehicleGroup,
  VehicleGroupSchema
);

export default vehicleGroupModel;

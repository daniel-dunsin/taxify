import mongoose from 'mongoose';
import { VehicleCategory } from '../@types/db';
import { createSchema } from '../../../utils';
import { DBCollections } from '../../../utils/constants';

const VehicleCategorySchema = createSchema<VehicleCategory>({
  name: {
    type: String,
  },
  image: {
    type: String,
  },
  map_image: {
    type: String,
  },
  rate_discount_amount: {
    type: Number,
    min: 0,
    default: 0,
  },
});

const vehicleCategoryModel = mongoose.model(
  DBCollections.VehicleCategory,
  VehicleCategorySchema
);

export default vehicleCategoryModel;

import { asyncHandler } from '../../../utils';
import * as vehicleService from '../services/vehicle.service';

export const getVehicleCategories = asyncHandler(async (req, res) => {
  const data = await vehicleService.getVehicleCategories();

  return data;
});

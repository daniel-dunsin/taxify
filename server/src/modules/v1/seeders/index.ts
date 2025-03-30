import Logger from '../../../configs/logger';
import vehicleCategoryModel from '../models/vehicle-category.model';
import vehicleGroupModel from '../models/vehicle-group.model';
import { VehicleCategories, VehicleGroups } from './seeds';

const logger = new Logger('seeders');

const seedVehicleCategories = async () => {
  const count = await vehicleCategoryModel.countDocuments({});

  if (count === 0) {
    logger.log('Seeding vehicle categories');
    await vehicleCategoryModel.create(VehicleCategories);
    logger.log('Seeded vehicle categories');
  }
};

const seedVehicleGroups = async () => {
  const count = await vehicleGroupModel.countDocuments({});

  if (count === 0) {
    logger.log('Seeding vehicle groups');
    await vehicleGroupModel.create(VehicleGroups);
    logger.log('Seeded vehicle groups');
  }
};

const runSeeds = async () => {
  logger.log('Running Seeds');

  try {
    await seedVehicleCategories();
    await seedVehicleGroups();

    logger.log('Seeding completed successfully');
  } catch (error) {
    logger.error(`Error occured while running seeds ${JSON.stringify(error)}`);
  }
};

export default runSeeds;

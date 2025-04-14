import Logger from '../../../configs/logger';
import paymentMethodModel from '../models/payment_methods.model';
import vehicleCategoryModel from '../models/vehicle-category.model';
import vehicleGroupModel from '../models/vehicle-group.model';
import { PaymentMethods, VehicleCategories, VehicleGroups } from './seeds';

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

const seedPaymentMethods = async () => {
  const count = await paymentMethodModel.countDocuments({});

  if (count === 0) {
    logger.log('Seeding payment methods');
    await paymentMethodModel.create(PaymentMethods);
    logger.log('Seeded payment methods');
  }
};

const runSeeds = async () => {
  logger.log('Running Seeds');

  try {
    await seedVehicleCategories();
    await seedVehicleGroups();
    await seedPaymentMethods();

    logger.log('Seeding completed successfully');
  } catch (error) {
    logger.error(`Error occured while running seeds ${JSON.stringify(error)}`);
  }
};

export default runSeeds;

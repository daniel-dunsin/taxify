import Logger from '../../../configs/logger';
import { HttpStatusCode } from '../../../utils/constants';
import { Role } from '../@types/enums';
import { HttpError } from '../@types/globals';
import driverModel from '../models/driver.model';
import { userModel } from '../models/user.model';
import vehicleModel from '../models/vehicle.model';
import walletModel from '../models/wallet.model';

const logger = new Logger('userService');

export const getUser = async (user_id: string) => {
  const user = await userModel
    .findById(user_id)
    .select('-createdAt -updatedAt');

  if (!user) throw new HttpError(HttpStatusCode.NotFound, 'User not found');

  let data;

  if (user.role != Role.Driver) {
    data = user;
  } else {
    const driver = await driverModel.findOne({ user });
    if (!driver)
      throw new HttpError(HttpStatusCode.NotFound, 'Driver profile not found');
    const wallet = await walletModel.findOne({ driver });
    const current_vehicle = await vehicleModel
      .findOne({ driver: driver._id, is_active: true })
      .select('_id group make model year category')
      .populate('category', '_id name image');

    data = {
      ...user?.toObject(),
      wallet_balance: wallet?.balance ?? 0,
      wallet_currency: wallet?.currency,
      wallet_currency_symbol: wallet?.currency_symbol,
      is_online: driver?.is_online,
      is_verified: driver?.is_verified,
      current_vehicle,
    };
  }

  return {
    success: true,
    msg: 'User profile retrieved successfully',
    data,
  };
};

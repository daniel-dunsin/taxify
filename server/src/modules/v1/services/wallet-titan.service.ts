import { HttpStatusCode } from '../../../utils/constants';
import { HttpError } from '../@types/globals';
import walletModel from '../models/wallet.model';

export const getWallet = async (user_id: string) => {
  const data = await walletModel
    .findOne({ user: user_id })
    .select('-user -driver -createdAt -updatedAt');

  if (!data) throw new HttpError(HttpStatusCode.NotFound, 'Wallet not found');

  return {
    success: true,
    msg: 'Wallet fetched successfully',
    data,
  };
};

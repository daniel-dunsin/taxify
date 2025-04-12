import { asyncHandler } from '../../../utils';
import * as walletTitanService from '../services/wallet-titan.service';

export const getWallet = asyncHandler((req, res) =>
  walletTitanService.getWallet(req.user?._id!)
);

export const createCard = asyncHandler((req, res) =>
  walletTitanService.createCard(req.user?._id!)
);

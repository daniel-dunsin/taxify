import { Request } from 'express';
import { asyncHandler } from '../../../utils';
import * as walletTitanService from '../services/wallet-titan.service';
import { UpdatePaymentMethodParams } from '../schemas/wallet-titan.schema';

export const getWallet = asyncHandler((req, res) =>
  walletTitanService.getWallet(req.user?._id!)
);

export const getUnavailablePaymentMethods = asyncHandler((req, res) =>
  walletTitanService.getUnavailablePaymentMethods(req.user?._id!)
);

export const getTopUpPaymentMethods = asyncHandler((req, res) =>
  walletTitanService.getTopUpPaymentMethods(req.user?._id!)
);

export const getRidePaymentMethods = asyncHandler((req, res) =>
  walletTitanService.getRidePaymentMethods(req.user?._id!)
);

export const deletePaymentMethod = asyncHandler(
  (req: Request<UpdatePaymentMethodParams>, res) =>
    walletTitanService.deletePaymentMethod(
      req.user?._id!,
      req.params?.payment_method_id!
    )
);

export const addPaymentMethod = asyncHandler(
  (req: Request<UpdatePaymentMethodParams>, res) =>
    walletTitanService.addPaymentMethod(
      req.user?._id!,
      req.params?.payment_method_id!
    )
);

import { Router } from 'express';
import {
  addPaymentMethod,
  deletePaymentMethod,
  getRidePaymentMethods,
  getTopUpPaymentMethods,
  getUnavailablePaymentMethods,
  getWallet,
} from '../controllers/wallet-titan.controller';
import { authMiddleware } from '../middlewares/auth.middleware';
import { Role } from '../@types/enums';
import { validationMiddleware } from '../schemas';
import { updatePaymentMethodSchema } from '../schemas/wallet-titan.schema';

const walletTitanRouter = Router();

walletTitanRouter.get('', authMiddleware(), getWallet);
walletTitanRouter.get(
  '/payment-methods/unavailable',
  authMiddleware([Role.User]),
  getUnavailablePaymentMethods
);
walletTitanRouter.get(
  '/payment-methods/ride',
  authMiddleware([Role.User]),
  getRidePaymentMethods
);
walletTitanRouter.get(
  '/payment-methods/top-up',
  authMiddleware([Role.User]),
  getTopUpPaymentMethods
);
walletTitanRouter.put(
  '/payment-methods/add/:payment_method_id',
  validationMiddleware(updatePaymentMethodSchema),
  authMiddleware([Role.User]),
  addPaymentMethod
);
walletTitanRouter.delete(
  '/payment-methods/remove/:payment_method_id',
  validationMiddleware(updatePaymentMethodSchema),
  authMiddleware([Role.User]),
  deletePaymentMethod
);

export default walletTitanRouter;

import { Router } from 'express';
import { getBanks, lookupAccount } from '../controllers/payment.controller';
import { validationMiddleware } from '../schemas';
import { lookupAccountSchema } from '../schemas/payment.schema';

const paymentRouter = Router();

paymentRouter.get('/banks', getBanks);
paymentRouter.get(
  '/resolve-account',
  validationMiddleware(lookupAccountSchema),
  lookupAccount
);

export default paymentRouter;

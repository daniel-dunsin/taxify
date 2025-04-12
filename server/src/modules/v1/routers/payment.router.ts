import { Router } from 'express';
import {
  getBanks,
  lookupAccount,
  processPaystackWebhook,
} from '../controllers/payment.controller';
import { validationMiddleware } from '../schemas';
import { lookupAccountSchema } from '../schemas/payment.schema';

const paymentRouter = Router();

paymentRouter.get('/banks', getBanks);
paymentRouter.get(
  '/resolve-account',
  validationMiddleware(lookupAccountSchema),
  lookupAccount
);
paymentRouter.post('/webhook/paystack', processPaystackWebhook);

export default paymentRouter;

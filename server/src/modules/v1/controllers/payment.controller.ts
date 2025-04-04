import { Request } from 'express';
import { asyncHandler } from '../../../utils';
import * as paymentService from '../services/payment.service';
import { LookupAccountDto } from '../schemas/payment.schema';

export const getBanks = asyncHandler((req, res) => paymentService.getBanks());

export const lookupAccount = asyncHandler((req, res) =>
  paymentService.lookupAccount(req.query as LookupAccountDto)
);

import { create, isEmpty, omit } from 'lodash';
import { paystackHttpInstance } from '../../../../configs/axios';
import Logger from '../../../../configs/logger';
import { Env, HttpStatusCode } from '../../../../utils/constants';
import { HttpError } from '../../@types/globals';
import {
  ChargeCard,
  ChargeResponse,
  CreateCustomer,
  CustomerResponse,
  InitiateCharge,
  InitiateRefund,
  PaystackResponse,
} from './types';
import crypto from 'crypto';
import { Request } from 'express';

const logger = new Logger('paystackProvider');

export const getFee = (amount: number) => {
  let fee = amount * 0.015;
  if (amount >= 2500) {
    fee += 100;
  }
  if (fee > 2000) {
    fee = 2000;
  }

  const grossAmount = amount + fee;
  return { fee: Math.round(fee), grossAmount: Math.round(grossAmount) };
};

const createCustomer = async (body: CreateCustomer) => {
  try {
    const response = await paystackHttpInstance.post<
      PaystackResponse<CustomerResponse>
    >('/customer', body);

    if (!response.data.status) {
      throw new HttpError(
        HttpStatusCode.InternalServerError,
        'Unable to create customer'
      );
    }

    logger.log('Customer created successfully');

    return response?.data?.data;
  } catch (error) {
    logger.error(JSON.stringify(error));
    throw error;
  }
};

const initiateCharge = async (body: InitiateCharge) => {
  const amount = body.fee_inclusive
    ? getFee(body.amount).grossAmount
    : body.amount;

  const payload = {
    ...omit(body, 'fee_inclusive'),
    amount: JSON.stringify(amount * 100),
    metadata: body?.metadata ? JSON.stringify(body.metadata) : undefined,
  };

  try {
    const response = await paystackHttpInstance.post<
      PaystackResponse<{
        authorization_url: string;
        access_code: string;
        reference: string;
      }>
    >('/transaction/initialize', payload);

    if (!response.data.status) {
      throw new HttpError(
        HttpStatusCode.InternalServerError,
        'Unable to initiate charge'
      );
    }

    logger.log('Charge initiated ✅');

    return response?.data?.data;
  } catch (error) {
    logger.error(JSON.stringify(error));
    throw error;
  }
};

const chargeCard = async (body: ChargeCard) => {
  const amount = body.fee_inclusive
    ? getFee(body.amount).grossAmount
    : body.amount;

  const payload = {
    ...omit(body, 'fee_inclusive'),
    amount: JSON.stringify(amount * 100),
    metadata: body?.metadata ? JSON.stringify(body.metadata) : undefined,
  };

  try {
    const response = await paystackHttpInstance.post<
      PaystackResponse<ChargeResponse>
    >('/transaction/charge_authorization', payload);

    if (!response.data.status) {
      throw new HttpError(
        HttpStatusCode.InternalServerError,
        'Unable to charge card'
      );
    }

    logger.log('Card charge initiated ✅');

    return response.data.data;
  } catch (error) {
    logger.error(JSON.stringify(error));
    throw error;
  }
};

const initiateRefund = async (body: InitiateRefund) => {
  const payload = {
    ...body,
    amount: body.amount ? JSON.stringify(body.amount * 1000) : undefined,
  };

  try {
    const response = await paystackHttpInstance.post<PaystackResponse>(
      '/refund',
      payload
    );

    if (!response.data.status) {
      throw new HttpError(
        HttpStatusCode.InternalServerError,
        'Unable to charge card'
      );
    }

    logger.log(`Refund initiated ${JSON.stringify(response.data.data)}`);

    return response?.data?.data;
  } catch (error: any) {
    console.log(error?.response?.data);
    logger.error(JSON.stringify(error));
    throw error;
  }
};

const webhookGuard = (req: Request) => {
  const hash = crypto
    .createHmac('sha512', Env.paystackSecretKey)
    .update(JSON.stringify(req.body))
    .digest('hex');

  if (hash !== req.headers['x-paystack-signature']) {
    throw new HttpError(
      HttpStatusCode.BadRequest,
      'Webhook is not from paystack'
    );
  }
};

const paystackProvider = {
  createCustomer,
  initiateCharge,
  chargeCard,
  initiateRefund,
  webhookGuard,
};

export default paystackProvider;

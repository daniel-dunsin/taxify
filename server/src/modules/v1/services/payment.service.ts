import axios from 'axios';
import { paystackHttpInstance } from '../../../configs/axios';
import Logger from '../../../configs/logger';
import { HttpStatusCode } from '../../../utils/constants';
import { HttpError } from '../@types/globals';
import { LookupAccountDto } from '../schemas/payment.schema';
import {
  ChargeResponse,
  RefundResponse,
  WebhookResponse,
} from '../providers/paystack/types';
import transactionModel from '../models/transaction.model';
import {
  PaymentMethods,
  TranasactionReason,
  TransactionStatus,
} from '../@types/enums';
import { Transaction } from '../@types/db';
import { isEmpty } from 'lodash';
import cardModel from '../models/card.model';
import { userModel } from '../models/user.model';
import paystackProvider from '../providers/paystack';
import pushQueue from '../queues/push-notification';
import walletModel from '../models/wallet.model';
import paymentMethodModel from '../models/payment_methods.model';

const logger = new Logger('PaymentService');
const webhookLogger = new Logger('webhookService');

export const getBanks = async () => {
  try {
    const response = await axios.get('https://nigerianbanks.xyz/');

    return {
      success: true,
      msg: 'Banks retrieved successfully',
      data: response.data,
    };
  } catch (error) {
    logger.error(`Error getting banks: ${JSON.stringify(error)}`);
    throw new HttpError(
      HttpStatusCode.InternalServerError,
      'Unable to get banks'
    );
  }
};

export const lookupAccount = async (lookupAccountDto: LookupAccountDto) => {
  const { account_number, bank_code } = lookupAccountDto!;

  try {
    const response = await paystackHttpInstance.get(
      `/bank/resolve?account_number=${account_number}&bank_code=${bank_code}`
    );

    if (!response.data.status) {
      throw new Error(response.data.message);
    }

    return {
      success: true,
      msg: 'Account number resolved',
      data: response.data.data,
    };
  } catch (error) {
    logger.error(`Error resolving account number: ${JSON.stringify(error)}`);
    throw new HttpError(
      HttpStatusCode.InternalServerError,
      'Unable to resolve account number'
    );
  }
};

const processFundWallet = async (webhookData: ChargeResponse) => {
  const transaction = await transactionModel.findOne({
    transaction_reference: webhookData.reference,
  });

  if (!transaction)
    throw new HttpError(HttpStatusCode.NotFound, 'Transaction not found');

  const user = await userModel.findOne({ _id: transaction.user });

  if (!user) throw new HttpError(HttpStatusCode.NotFound, 'User not found');

  await walletModel.updateOne(
    { user: user._id },
    { $inc: { balance: transaction.subtotal } }
  );

  transaction.status = TransactionStatus.Successful;
  await transaction.save();

  await pushQueue.add({
    title: 'Card charge',
    body: `Your card charge was successful, your wallet has been funded with ₦${transaction.subtotal?.toLocaleString()}`,
    user_id: user?._id,
    data: {
      redirect_url: '/account/wallet',
    },
  });
};

const processCardCharge = async (webhookData: ChargeResponse) => {
  const transaction = await transactionModel.findOne({
    transaction_reference: webhookData.reference,
  });

  if (!transaction)
    throw new HttpError(HttpStatusCode.NotFound, 'Transaction not found');

  const user = await userModel.findOne({ _id: transaction.user });

  if (!user) throw new HttpError(HttpStatusCode.NotFound, 'User not found');

  if (!isEmpty(webhookData.authorization)) {
    const card_payment_method = await paymentMethodModel.findOne({
      name: PaymentMethods.CARD,
    });

    await cardModel.create({
      ...webhookData.authorization,
      user: transaction.user,
      email: user?.email,
      is_active: true,
    });

    await walletModel.updateOne(
      { user: user._id },
      {
        $push: {
          payment_methods: card_payment_method?._id,
        },
      }
    );

    logger.log(`Card created for ${user?.email} processing refund...`);

    await pushQueue.add({
      user_id: String(transaction.user),
      title: 'Card Created',
      body: `Your ₦${transaction.amount?.toLocaleString()} for card charge was successful, your card has been created and your refund is being processed`,
      data: {
        redirect_url: '/account/wallet',
      },
    });

    await paystackProvider.initiateRefund({
      transaction: webhookData.id,
      currency: 'NGN',
      merchant_note: 'Card charge refund',
    });
  }
};

const processRefund = async (webhookData: RefundResponse) => {
  const transaction = await transactionModel.findOneAndUpdate({
    transaction_reference: webhookData.transaction_reference,
  });

  if (!transaction)
    throw new HttpError(HttpStatusCode.NotFound, 'Transaction not found');

  transaction.status = TransactionStatus.Refunded;
  transaction.amount_refunded = webhookData.amount;
  await transaction.save();

  await pushQueue.add({
    user_id: String(transaction.user),
    title: 'Card Charge',
    body: `Your ₦${transaction.amount?.toLocaleString()} for card charge has been refunded`,
    data: {
      redirect_url: '/account/wallet',
    },
  });
};

const processFailedRefund = async (webhookData: RefundResponse) => {
  const transaction = await transactionModel.findOneAndUpdate({
    transaction_reference: webhookData.transaction_reference,
  });

  if (!transaction)
    throw new HttpError(HttpStatusCode.NotFound, 'Transaction not found');

  transaction.status = TransactionStatus.Refunded;
  await transaction.save();

  await walletModel.updateOne(
    {
      _id: transaction.wallet,
    },
    {
      $inc: {
        balance: transaction?.amount,
      },
    }
  );

  await pushQueue.add({
    user_id: String(transaction.user),
    title: 'Refund failed',
    body: 'We were unable to process your refund, your money has been credited to your in app wallet',
    data: {
      redirect_url: '/account/wallet',
    },
  });
};

export const processPaystackWebhook = async (body: WebhookResponse) => {
  try {
    const { event, data } = body;

    switch (event) {
      case 'charge.success': {
        const response_data = data as ChargeResponse;
        const transaction_reference = response_data?.reference;

        const transaction = JSON.parse(response_data.metadata);

        switch (transaction.payment_for) {
          case TranasactionReason.FundWallet:
            await processFundWallet(response_data);
            break;
          case TranasactionReason.Ride:
            break;
          case TranasactionReason.ChargeCard:
            await processCardCharge(response_data);
            break;
        }

        await transactionModel.updateOne(
          { transaction_reference },
          {
            provider_transaction_id: response_data?.id,
            status: TransactionStatus.Successful,
          }
        );

        break;
      }
      case 'refund.failed': {
        await processFailedRefund(data as RefundResponse);
        break;
      }
      case 'refund.processed': {
        await processRefund(data as RefundResponse);
        break;
      }
      case 'transfer.failed':
      case 'transfer.success':
      case 'transfer.reversed':
        throw new HttpError(HttpStatusCode.NotImplemented, 'Not implemented');
    }

    webhookLogger.log(`Webhook ran successfully ${JSON.stringify(body)}`);
    return true;
  } catch (error) {
    console.log(error);
    webhookLogger.error(
      `Webhook failed, \nerror: ${JSON.stringify(
        error
      )}, \nbody:${JSON.stringify(body)}`
    );

    return false;
  }
};

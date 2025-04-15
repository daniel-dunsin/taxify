import { HttpStatusCode } from '../../../utils/constants';
import { BankDetails, Card, Transaction, User, Wallet } from '../@types/db';
import { HttpError } from '../@types/globals';
import walletModel from '../models/wallet.model';
import cardModel from '../models/card.model';
import transactionModel from '../models/transaction.model';
import {
  PaymentMethods,
  PaystackChannels,
  Role,
  TranasactionReason,
  TransactionDirection,
  TransactionStatus,
} from '../@types/enums';
import * as walletService from './wallet-titan.service';
import { generateUniqueModelProperty } from '../../../utils';
import paystackProvider from '../providers/paystack';
import { userModel } from '../models/user.model';
import paymentMethodModel from '../models/payment_methods.model';
import { FundWalletDto } from '../schemas/wallet-titan.schema';
import { HydratedDocument } from 'mongoose';

export const getWallet = async (user_id: string) => {
  const user = await userModel.findOne({ _id: user_id });

  if (!user) throw new HttpError(HttpStatusCode.NotFound, 'User not found');

  const wallet = await walletModel
    .findOne({ user: user_id })
    .select('-user -driver -createdAt -updatedAt')
    .populate({
      path: 'payment_methods',
      options: { name: { $ne: PaymentMethods.WALLET } },
      select: '-updatedAt -createdAt',
    });

  if (!wallet) throw new HttpError(HttpStatusCode.NotFound, 'Wallet not found');

  const data: any = {
    ...wallet.toObject(),
  };

  if (user.role == Role.User) {
    data.payment_methods = await Promise.all(
      data.payment_methods?.map(async (pm: any) => {
        if (pm.name === PaymentMethods.CARD) {
          const card = await cardModel
            .findOne({
              user: user_id,
              is_active: true,
            })
            .select(
              'bin last4 exp_month exp_year bank country_code brand account_name'
            );
          pm.card = card!;
        }

        return pm;
      })
    );
  } else {
    delete data.payment_methods;
  }

  return {
    success: true,
    msg: 'Wallet fetched successfully',
    data,
  };
};

export const createWallet = async (
  user: User & { driver_id?: string } & Partial<BankDetails>
) => {
  const paystack_customer = await paystackProvider.createCustomer({
    email: user.email,
    first_name: user.firstName,
    last_name: user.lastName,
    phone: user.phoneNumber,
  });

  const existingWallet = await walletModel.findOne({
    $or: [
      { paystack_customer_code: paystack_customer.customer_code },
      { paystack_customer_id: paystack_customer.id },
    ],
  });

  if (existingWallet) {
    throw new HttpError(
      HttpStatusCode.BadRequest,
      'Oops! a wallet already exists for this email address, use a different one'
    );
  }

  const default_payment_methods = await paymentMethodModel.find({
    is_default: true,
  });

  await walletModel.create({
    driver: user?.driver_id,
    user: user?._id,
    account_number: user?.account_number,
    account_name: user?.account_name,
    bank_name: user?.bank_name,
    bank_logo: user?.bank_logo,
    bank_code: user?.bank_code,
    paystack_customer_code: paystack_customer?.customer_code,
    paystack_customer_id: paystack_customer?.id,
    ...(user.role === Role.User
      ? { payment_methods: default_payment_methods }
      : {}),
  });
};

const createCard = async (userId: string) => {
  const user = await userModel.findById(userId);

  if (!user) throw new HttpError(HttpStatusCode.NotFound, 'User not found');

  const existing_card = await cardModel.findOne({
    user: userId,
    is_active: true,
  });

  if (existing_card) {
    throw new HttpError(HttpStatusCode.NotFound, 'Card not found');
  }

  const wallet = await walletService.getWallet(userId);
  const card_charge_amount = 50;
  const transaction_reference = await generateUniqueModelProperty(
    transactionModel,
    'transaction_reference',
    'TRX'
  );

  const card_payment_method = await paymentMethodModel.findOne({
    name: PaymentMethods.CARD,
  });

  const transaction = await transactionModel.create({
    payment_method: card_payment_method?._id,
    payment_for: TranasactionReason.ChargeCard,
    user: userId,
    wallet: wallet?.data?._id,
    amount: 50,
    currency: 'NGN',
    transaction_reference,
    direction: TransactionDirection.Debit,
    subtotal: card_charge_amount,
    processing_fee: 0,
  });

  const data = await paystackProvider.initiateCharge({
    amount: card_charge_amount,
    fee_inclusive: false,
    email: user?.email,
    reference: transaction_reference,
    metadata: JSON.stringify(transaction),
    channels: [PaystackChannels.card],
    currency: 'NGN',
  });

  return data;
};

export const getUnavailablePaymentMethods = async (user_id: string) => {
  const wallet = await walletModel.findOne({ user: user_id });

  if (!wallet) throw new HttpError(HttpStatusCode.NotFound, 'Wallet not found');

  const data = await paymentMethodModel.find({
    _id: { $nin: wallet.payment_methods },
  });

  return {
    success: true,
    msg: 'Unavailable payment methods fetched',
    data,
  };
};

export const getTopUpPaymentMethods = async (user_id: string) => {
  const wallet = await walletModel.findOne({ user: user_id });

  if (!wallet) throw new HttpError(HttpStatusCode.NotFound, 'Wallet not found');

  const data = await paymentMethodModel.find({
    _id: { $in: wallet.payment_methods },
    is_for_topup: true,
  });

  return {
    success: true,
    msg: 'top-up payment methods fetched',
    data,
  };
};

export const getRidePaymentMethods = async (user_id: string) => {
  const wallet = await walletModel.findOne({ user: user_id });

  if (!wallet) throw new HttpError(HttpStatusCode.NotFound, 'Wallet not found');

  const data = await paymentMethodModel.find({
    _id: { $in: wallet.payment_methods },
    is_for_ride: true,
  });

  return {
    success: true,
    msg: 'ride payment methods fetched',
    data,
  };
};

export const deletePaymentMethod = async (
  user_id: string,
  paymentMethodId: string
) => {
  const paymentMethod = await paymentMethodModel.findById(paymentMethodId);

  if (!paymentMethod)
    throw new HttpError(HttpStatusCode.NotFound, 'Payment method not found');
  if (paymentMethod.is_default)
    throw new HttpError(
      HttpStatusCode.BadRequest,
      "You can't remove a default payment method"
    );

  const wallet = await walletModel.findOne({ user: user_id });

  if (!wallet) throw new HttpError(HttpStatusCode.NotFound, 'Wallet not found');
  if (!wallet.payment_methods?.includes?.(paymentMethodId))
    throw new HttpError(
      HttpStatusCode.NotFound,
      'Payment method not found in profile'
    );

  await walletModel.updateOne(
    { _id: wallet._id },
    { $pull: { payment_methods: paymentMethodId } }
  );

  if (paymentMethod.name === PaymentMethods.CARD) {
    await cardModel.updateOne(
      { user: wallet.user, is_active: true },
      { is_active: false }
    );
  }

  return {
    success: true,
    msg: 'Payment method removed',
  };
};

export const addPaymentMethod = async (
  user_id: string,
  paymentMethodId: string
) => {
  const paymentMethod = await paymentMethodModel.findById(paymentMethodId);

  if (!paymentMethod)
    throw new HttpError(HttpStatusCode.NotFound, 'Payment method not found');

  const wallet = await walletModel.findOne({ user: user_id });

  if (!wallet) throw new HttpError(HttpStatusCode.NotFound, 'Wallet not found');
  if (wallet.payment_methods?.includes?.(paymentMethodId))
    throw new HttpError(
      HttpStatusCode.NotFound,
      'Payment method has been added to wallet already'
    );

  if (paymentMethod.name != PaymentMethods.CARD) {
    await walletModel.updateOne(
      { _id: wallet._id },
      { $push: { payment_methods: paymentMethodId } }
    );

    return {
      success: true,
      msg: 'Payment method added',
      meta: {
        has_authorization: false,
      },
    };
  } else {
    const data = await createCard(user_id);

    return {
      success: true,
      msg: 'Payment method creation initiated',
      data,
      meta: {
        has_authorization: true,
      },
    };
  }
};

export const fundWallet = async (user_id: string, body: FundWalletDto) => {
  const { amount, payment_method_id } = body!;

  const payment_method = await paymentMethodModel.findById(payment_method_id);

  if (!payment_method)
    throw new HttpError(HttpStatusCode.NotFound, 'Payment method not found');
  if (!payment_method.is_for_topup)
    throw new HttpError(
      HttpStatusCode.BadRequest,
      'Payment method not allowed for top-up'
    );
  if (!payment_method.paystack_channel)
    throw new HttpError(
      HttpStatusCode.BadRequest,
      'Payment method not in use yet!'
    );

  const user = await userModel.findById(user_id);

  if (!user) throw new HttpError(HttpStatusCode.NotFound, 'User not found');

  const wallet = await walletModel.findOne({ user: user_id });

  if (!wallet) throw new HttpError(HttpStatusCode.NotFound, 'Wallet not found');
  if (!wallet.payment_methods?.includes(payment_method_id)) {
    throw new HttpError(
      HttpStatusCode.BadRequest,
      'Payment method not allowed'
    );
  }

  const { fee, grossAmount } = paystackProvider.getFee(amount!);

  const transaction_reference = await generateUniqueModelProperty(
    transactionModel,
    'transaction_reference',
    'TRX'
  );

  const transaction = await transactionModel.create({
    payment_method: payment_method._id,
    payment_for: TranasactionReason.FundWallet,
    user: user_id,
    wallet: wallet._id,
    amount: grossAmount,
    currency: 'NGN',
    transaction_reference,
    status: TransactionStatus.Pending,
    direction: TransactionDirection.Credit,
    subtotal: amount!,
    processing_fee: fee,
  });

  let data;
  let redirect_to_provider;

  if (payment_method.name != PaymentMethods.CARD) {
    data = await paystackProvider.initiateCharge({
      amount: amount!,
      email: user?.email,
      fee_inclusive: true,
      currency: 'NGN',
      reference: transaction_reference,
      metadata: JSON.stringify(transaction),
      channels: [payment_method.paystack_channel],
    });

    redirect_to_provider = true;
  } else {
    const card = await cardModel.findOne({ user: user_id, is_active: true });

    if (!card) throw new HttpError(HttpStatusCode.NotFound, 'Card not found');

    transaction.card = card;
    await transaction.save();

    await paystackProvider.chargeCard({
      authorization_code: card.authorization_code,
      email: card.email,
      amount: amount!,
      fee_inclusive: true,
      reference: transaction_reference,
      metadata: JSON.stringify(transaction),
      currency: 'NGN',
    });

    redirect_to_provider = false;
  }

  return {
    success: true,
    msg: redirect_to_provider ? 'Wallet funding initiated' : 'Wallet funded',
    data,
    meta: {
      redirect_to_provider,
    },
  };
};

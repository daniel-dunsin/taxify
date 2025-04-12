import { HttpStatusCode } from '../../../utils/constants';
import { BankDetails, User } from '../@types/db';
import { HttpError } from '../@types/globals';
import walletModel from '../models/wallet.model';
import cardModel from '../models/card.model';
import transactionModel from '../models/transaction.model';
import {
  PaymentMethods,
  PaystackChannels,
  TranasactionReason,
  TransactionDirection,
} from '../@types/enums';
import * as walletService from './wallet-titan.service';
import { generateUniqueModelProperty } from '../../../utils';
import paystackProvider from '../providers/paystack';
import { userModel } from '../models/user.model';

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
  });
};

export const createCard = async (userId: string) => {
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

  const transaction = await transactionModel.create({
    payment_method: PaymentMethods.CARD,
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

  return {
    success: true,
    msg: 'Charge initiated',
    data,
  };
};

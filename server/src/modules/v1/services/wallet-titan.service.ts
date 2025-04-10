import { HttpStatusCode } from '../../../utils/constants';
import { BankDetails, User } from '../@types/db';
import { HttpError } from '../@types/globals';
import walletModel from '../models/wallet.model';
import paystackProvider from '../providers/paystack';

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

import { paystackHttpInstance } from '../../../configs/axios';
import Logger from '../../../configs/logger';
import { HttpStatusCode } from '../../../utils/constants';
import { HttpError } from '../@types/globals';
import { LookupAccountDto } from '../schemas/payment.schema';

const logger = new Logger('PaymentService');

export const getBanks = async () => {
  try {
    const response = await paystackHttpInstance.get('/bank');

    if (!response.data.status) {
      throw new Error(response.data.message);
    }

    return {
      success: true,
      msg: 'Banks retrieved successfully',
      data: response.data.data,
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

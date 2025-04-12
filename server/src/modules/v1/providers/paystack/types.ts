import { PaystackChannels } from '../../@types/enums';

export interface InitiateCharge {
  amount: number;
  email: string;
  currency: 'NGN';
  reference: string;
  metadata?: any;
  channels?: PaystackChannels[];
  fee_inclusive: boolean;
}

export interface ChargeCard {
  email: string;
  amount: number;
  authorization_code: string;
  fee_inclusive: boolean;
  currency: 'NGN';
  reference: string;
  metadata?: any;
}

export interface CreateCustomer {
  email: string;
  first_name: string;
  last_name: string;
  phone: string;
}

export interface InitiateRefund {
  transaction: number;
  amount?: number;
  currency: 'NGN';
  merchant_note: string;
}

export interface CustomerResponse {
  first_name: string;
  last_name: string;
  email: string;
  phone: string;
  customer_code: string;
  id: number;
}

export interface RefundResponse {
  status: 'processed' | 'processing' | 'pending' | 'failed';
  transaction_reference: string;
  amount: number;
  currency: 'NGN';
  customer: CustomerResponse;
}

export interface CardAuthorization {
  authorization_code: string;
  bin: string;
  last4: string;
  exp_month: string;
  exp_year: string;
  bank: string;
  country_code: string;
  brand: string;
  account_name: string;
  signature: string;
}

export interface ChargeResponse {
  status: 'failed' | 'success';
  reference: string;
  amount: number;
  ip_address: string;
  fees: number;
  customer: CustomerResponse;
  authorization: CardAuthorization;
  id: number;
  metadata: string;
}

export interface PaystackResponse<T = any> {
  status: boolean;
  message: string;
  data: T;
}

export interface WebhookResponse<T = ChargeResponse | RefundResponse> {
  event: WebhookEvents;
  data: T;
}

export type WebhookEvents =
  | 'charge.success'
  | 'refund.failed'
  | 'refund.processed'
  | 'refund.processing'
  | 'transfer.failed'
  | 'transfer.success'
  | 'transfer.reversed';

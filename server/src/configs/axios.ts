import axios from 'axios';
import { Env } from '../utils/constants';

export const paystackHttpInstance = axios.create({
  baseURL: 'https://api.paystack.co/',
  headers: {
    'Content-Type': 'application/json',
    Authorization: `Bearer ${Env.paystackSecretKey}`,
  },
});

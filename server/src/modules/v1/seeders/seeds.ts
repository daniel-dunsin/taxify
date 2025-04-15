import { PaymentMethod, VehicleCategory, VehicleGroup } from '../@types/db';
import {
  PaystackChannels,
  VehicleType,
  PaymentMethods as PaymentMethodsEnum,
} from '../@types/enums';

export const VehicleCategories: Omit<
  VehicleCategory,
  '_id' | 'createdAt' | 'updatedAt'
>[] = [
  {
    name: 'Bike',
    image:
      'https://res.cloudinary.com/denettr1i/image/upload/v1743691949/small_bike-removebg-preview__1___1_-removebg-preview_1_i0gm30.png',
    rate_discount_amount: 2000,
  },
  {
    name: 'Car',
    image:
      'https://res.cloudinary.com/denettr1i/image/upload/v1743292441/small_car_eo6uf0.png',
    rate_discount_amount: 0,
    map_image:
      'https://res.cloudinary.com/denettr1i/image/upload/v1743292441/map_car_mpjuus.png',
  },
  {
    name: 'Truck',
    image:
      'https://res.cloudinary.com/denettr1i/image/upload/v1743292441/small_truck_vdcls1.png',
    rate_discount_amount: 0,
    map_image:
      'https://res.cloudinary.com/denettr1i/image/upload/v1743292440/map_truck_bmtlxb.png',
  },
];

export const VehicleGroups: Omit<
  VehicleGroup,
  '_id' | 'createdAt' | 'updatedAt'
>[] = [
  {
    name: VehicleType.Economy,
    min_fare: 3000,
    rate_per_km: 500,
    description: 'Affordable rides for individuals or small groups',
  },
  {
    name: VehicleType.Luxury,
    min_fare: 5000,
    rate_per_km: 1000,
    description: 'High-end cars for premium service',
  },
  {
    name: VehicleType.SUV,
    min_fare: 6000,
    rate_per_km: 1500,
    description: 'Large Vehicles for Groups & Comfort',
  },
];

export const PaymentMethodsSeed: Omit<
  PaymentMethod,
  '_id' | 'createdAt' | 'updatedAt'
>[] = [
  {
    name: PaymentMethodsEnum.CASH,
    description:
      "Your driver's phone will show you the amount to pay at the end of the trip",
    icon: 'https://res.cloudinary.com/dyq7aipu8/image/upload/v1744702566/money_3636023_svhm4o.png',
    is_for_ride: true,
    is_for_topup: false,
    is_default: true,
  },
  {
    name: PaymentMethodsEnum.USSD,
    description: 'You can now top-up your Taxify balance with USSD',
    icon: 'https://res.cloudinary.com/dyq7aipu8/image/upload/v1744702565/smartphone_2824165_tmawxb.png',
    is_default: false,
    is_for_ride: false,
    is_for_topup: true,
    paystack_channel: PaystackChannels.ussd,
  },
  {
    name: PaymentMethodsEnum.BANK_TRANSFER,
    description: 'You can now top-up your Taxify balance with Bank transfer',
    icon: 'https://res.cloudinary.com/dyq7aipu8/image/upload/v1744702758/safebox_2254690_mjuhdr.png',
    is_default: false,
    is_for_ride: false,
    is_for_topup: true,
    paystack_channel: PaystackChannels.bank_transfer,
  },
  {
    name: PaymentMethodsEnum.CARD,
    description:
      'You can now top-up your Taxify balance and pay for rides with your credit or debit card',
    icon: 'https://res.cloudinary.com/dyq7aipu8/image/upload/v1744702566/payment-mehotd_12261842_dfpozd.png',
    is_default: false,
    is_for_ride: true,
    is_for_topup: true,
    paystack_channel: PaystackChannels.card,
  },
  {
    name: PaymentMethodsEnum.WALLET,
    description: 'You can pay for rides with your Taxify wallet balance',
    icon: 'https://res.cloudinary.com/dyq7aipu8/image/upload/v1744702759/wallet_584026_bae3xm.png',
    is_default: true,
    is_for_ride: true,
    is_for_topup: false,
  },
];

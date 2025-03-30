import { VehicleCategory, VehicleGroup } from '../@types/db';
import { VehicleType } from '../@types/enums';

export const VehicleCategories: Omit<
  VehicleCategory,
  '_id' | 'createdAt' | 'updatedAt'
>[] = [
  {
    name: 'Bike',
    image:
      'https://res.cloudinary.com/denettr1i/image/upload/v1743292443/small_bike_f1z55m.jpg',
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

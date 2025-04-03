import { VehicleType } from '../@types/enums';
import vehicleCategoryModel from '../models/vehicle-category.model';

export const getVehicleGroup = ({
  cateogryName,
  make,
  model,
  passengers,
  year,
}: {
  cateogryName: string;
  make: string;
  model: string;
  passengers: number;
  year: number;
}) => {
  const luxuryBrands = [
    'BMW',
    'Mercedes-Benz',
    'Audi',
    'Lexus',
    'Tesla',
    'Porsche',
    'Rolls-royce',
    'Lamborghini',
  ].map((r) => r.toLowerCase());
  const suvKeywords = [
    'Highlander',
    'Pilot',
    'Explorer',
    'Tahoe',
    'Pathfinder',
    'X5',
    'GLE',
    'Q7',
  ].map((r) => r.toLowerCase());
  const economyBrands = [
    'Toyota',
    'Honda',
    'Nissan',
    'Hyundai',
    'Kia',
    'Ford',
    'Chevrolet',
  ].map((r) => r.toLowerCase());

  if (cateogryName === 'Truck' || cateogryName === 'Bike') {
    return VehicleType.Economy;
  }

  if (
    passengers >= 6 ||
    suvKeywords.some((keyword) => model.includes(keyword))
  ) {
    return VehicleType.SUV;
  }

  if (luxuryBrands.includes(make.toLowerCase())) {
    return VehicleType.Luxury;
  }

  if (economyBrands.includes(make.toLowerCase()) && year >= 2023) {
    return VehicleType.Luxury;
  }

  return VehicleType.Economy;
};

export const getVehicleCategories = async () => {
  const data = await vehicleCategoryModel
    .find()
    .sort({ name: 1 })
    .select('_id name image');

  return {
    data,
    success: true,
    message: 'Vehicle categories fetched',
  };
};

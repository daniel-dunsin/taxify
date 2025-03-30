import { VehicleType } from '../@types/enums';

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

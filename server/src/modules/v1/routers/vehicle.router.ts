import { Router } from 'express';
import { getVehicleCategories } from '../controllers/vehicle.controller';

const vehicleRouter = Router();

vehicleRouter.get('/category', getVehicleCategories);

export default vehicleRouter;

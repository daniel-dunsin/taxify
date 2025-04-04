import { Router } from 'express';
import authRouter from './routers/auth.router';
import vehicleRouter from './routers/vehicle.router';
import paymentRouter from './routers/payment.router';

const router = Router();

router.get('health-check', (req, res) => {
  res.status(200).json({ status: 'OK' });
});

router.use('/auth', authRouter);
router.use('/vehicle', vehicleRouter);
router.use('/payment', paymentRouter);

export default router;

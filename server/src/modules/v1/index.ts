import { Router } from 'express';
import authRouter from './routers/auth.router';
import vehicleRouter from './routers/vehicle.router';
import paymentRouter from './routers/payment.router';
import userRouter from './routers/user.router';
import walletTitanRouter from './routers/wallet-titan.router';

const router = Router();

router.get('health-check', (req, res) => {
  res.status(200).json({ status: 'OK' });
});

router.use('/auth', authRouter);
router.use('/user', userRouter);
router.use('/vehicle', vehicleRouter);
router.use('/payment', paymentRouter);
router.use('/wallet-titan', walletTitanRouter);

export default router;

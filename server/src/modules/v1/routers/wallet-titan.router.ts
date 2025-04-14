import { Router } from 'express';
import { getWallet } from '../controllers/wallet-titan.controller';
import { authMiddleware } from '../middlewares/auth.middleware';

const walletTitanRouter = Router();

walletTitanRouter.get('', authMiddleware(), getWallet);

export default walletTitanRouter;

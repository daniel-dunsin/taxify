import { Router } from 'express';
import { createCard, getWallet } from '../controllers/wallet-titan.controller';
import { authMiddleware } from '../middlewares/auth.middleware';

const walletTitanRouter = Router();

walletTitanRouter.get('', authMiddleware(), getWallet);
walletTitanRouter.post('/create-card', authMiddleware(), createCard);

export default walletTitanRouter;

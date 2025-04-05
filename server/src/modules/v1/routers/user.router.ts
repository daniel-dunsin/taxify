import { Router } from 'express';
import { authMiddleware } from '../middlewares/auth.middleware';
import { getUser } from '../controllers/user.controller';

const userRouter = Router();

userRouter.get('', authMiddleware(), getUser);

export default userRouter;

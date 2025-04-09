import { Router } from 'express';
import { validationMiddleware } from '../schemas';
import {
  driverSignUpSchema,
  loginWithOtpSchema,
  requestLoginOtpSchema,
  resendSignUpOtpSchema,
  userSignUpSchema,
  verifyAccountSchema,
} from '../schemas/auth.schema';
import {
  loginWithOtp,
  requestLoginOtp,
  resendSignUpOtp,
  signOut,
  signUpDriver,
  signUpUser,
  verifyAccount,
} from '../controllers/auth.controller';
import { authMiddleware } from '../middlewares/auth.middleware';

const authRouter = Router();

authRouter.post(
  '/sign-up/user',
  validationMiddleware(userSignUpSchema),
  signUpUser
);

authRouter.post(
  '/sign-up/driver',
  validationMiddleware(driverSignUpSchema),
  signUpDriver
);

authRouter.post(
  '/sign-up/resend-otp',
  validationMiddleware(resendSignUpOtpSchema),
  resendSignUpOtp
);

authRouter.post(
  '/verify-account',
  validationMiddleware(verifyAccountSchema),
  verifyAccount
);

authRouter.post(
  '/request-login-otp',
  validationMiddleware(requestLoginOtpSchema),
  requestLoginOtp
);

authRouter.post(
  '/login-with-otp',
  validationMiddleware(loginWithOtpSchema),
  loginWithOtp
);

authRouter.get('/sign-out', authMiddleware(), signOut);

export default authRouter;

import { Request } from 'express';
import { asyncHandler } from '../../../utils';
import * as authService from '../services/auth.service';
import {
  DriverSignUpDto,
  LoginWithOtpDto,
  RequestLoginOtpDto,
  ResendSignUpOtpDto,
  UserSignUpDto,
  VerifyAccountDto,
} from '../schemas/auth.schema';

export const signUpUser = asyncHandler(
  async (req: Request<{}, {}, UserSignUpDto>) =>
    await authService.signUpUser(req.body)
);

export const resendSignUpOtp = asyncHandler(
  async (req: Request<{}, {}, ResendSignUpOtpDto>) =>
    await authService.resendSignUpOtp(req.body)
);

export const verifyAccount = asyncHandler(
  async (req: Request<{}, {}, VerifyAccountDto>) =>
    await authService.verifyAccount(req.body)
);

export const requestLoginOtp = asyncHandler(
  async (req: Request<{}, {}, RequestLoginOtpDto>) =>
    await authService.requestLoginOtp(req.body)
);

export const loginWithOtp = asyncHandler(
  async (req: Request<{}, {}, LoginWithOtpDto>) =>
    await authService.loginWithOtp(req.body)
);

export const signUpDriver = asyncHandler(
  async (req: Request<{}, {}, DriverSignUpDto>) =>
    await authService.signUpDriver(req.body)
);

export const signOut = asyncHandler(
  async (req) => await authService.signOut(req.user?._id!)
);
